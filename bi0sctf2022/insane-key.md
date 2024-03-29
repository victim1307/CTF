<https://dnaeon.github.io/openssh-private-key-binary-format/>

First we have to replace the ?s with something, I will replace them all with '/'s
then convert the b64 to hex.

```python
>>> key = open("key").read().replace('?','/')
>>> open("key", "w").write(key)
```


Now I will highlight some headers green, non-mathematical pink and known blue.
<img width="1072" alt="image" src="https://user-images.githubusercontent.com/78896740/213923856-86442990-0613-46ac-a2e6-67046cb87411.png">


So, what values are known?

We have e=0x010001, followed by n_upper, followed by n_lower, followed by e again.
Almost all of d is unknown so ignore that.
Then we have the full value of iqmp, the upper section of p, then a middle and lower section of q.

n_upper and n_lower actually overlap, allowing you to get the full value for n.


```python
e = 0x010001
n = 0x00c0d76392ed01ca0729a8a0aaecbf09ee5814806fb7d0cb4fe97c81a6b48b6fd86eefdeebc71a33305f4b64c5b55b342a9dbc09ba081a2a0293e6e3b09f3f290a8c8f1c08aa28a3c830c58bc5ff97b2dc7b309e576673180ec0f8273099bc9ff84e477ade15279ca2fbc7e2df3e59dd7705e2339ca306141487a7454b6d3e7188dea6530bfee5892c0583c6132c613c0c5c1ed7f0d1a97d306fa666964bf50e11d10b3fe7d54574b815532d763979b6f5625d9823fb7c2186727197ef158bce3e3575267a79baa1819ed1d2de595ebf9ffb909b8df2a8e9efbe73f490a0cd35a4d8f02a7bd3dd5652c9d6902e75e1e9bf75df3a7da23bd7e97350b71546868161d6ab486c610471b80334745c03dac178266b32aff70fd62799f1e8da324db32fbf5b502ee45f9ff263d55f0498cfbc50b77cab263447cfcded4b5cd2ed6302276b6b69b30a4d44232c95dd2f1ae5e993577a591958b4c61ef1a9755d3641b470c127108f0a9fbe715bbc3082fe260afbeb578c229ce511a096ee492955378907

iqmp = 0x67a20eff99da8fd3a85d2ea87d2ff339bde448035e19cb042693608c7e630aa4a71a7c6f66b692a2c1c57169943f90947ff29fcfc3ae1bce6edf1d09600b73a952b2b34fa3d26e2a9adb84df29dda24e982de676e468a50d273c4de535bf8a11503889f339d9428fdee8f07ca7dd89768ab0ee6a72e3829514d0df9d1330be467b7999369d6699b16945a87787ea540fbc828280a23de75e573d0a6d4fb10d526b71e3a55e7b41db39d0bf773609eeaa7cc018e279aca93125c23107568e687e

p_upper = 0x00f9d7c6fd164e3356ab83542c49f982ba340086758918d
q_middle = 0xc570613da06c478
q_lower = 0x691738dc8996d
```


Use p_upper to solve q_upper:


```python
>>> hex(n//p_upper)[:len(hex(p_upper))-2]
'0xc597ff4fc78fabff87fd021ee21d02e2b2f726cbe12'
```

Let u = iqmp

$$u = q^{-1}\ mod\ p$$

$$u \cdot q \equiv 1\ mod\ p$$

$$u \cdot q - 1 = k\cdot p$$

$$u \cdot q^2 - q = k\cdot p \cdot q$$

$$u \cdot q^2 - q \equiv 0\ (mod\ n)$$

Recover q with bivariate coppersmith:

```python
from sage.rings.polynomial.multi_polynomial_sequence import PolynomialSequence
from tqdm import tqdm
import itertools

def solve_system_with_jacobian(H, f, bounds, iters=100, prec=1000):
    vs = list(f.variables())
    n = f.nvariables()
    x = f.parent().objgens()[1]
    x_ = [var(str(vs[i])) for i in range(n)]
    for ii in Combinations(range(len(H)), k=n):
        f = symbolic_expression([H[i](x) for i in ii]).function(x_)
        jac = jacobian(f, x_)
        v = vector([t // 2 for t in bounds])
        for _ in tqdm(range(iters)):
            kwargs = {str(vs[i]): v[i] for i in range(n)}
            try:
                tmp = v - jac(**kwargs).inverse() * f(**kwargs)
            except ZeroDivisionError:
                return None
            v = vector((numerical_approx(d, prec=prec) for d in tmp))
        v = [int(_.round()) for _ in v]
        if H[0](v) == 0:
            return tuple(v)
    return None


def coppersmith(f, bounds, m=1, d=None):
    # https://github.com/josephsurin/lattice-based-cryptanalysis/blob/main/lbc_toolkit/problems/small_roots.sage

    if d is None:
        d = f.degree()

    R = f.base_ring()
    N = R.cardinality()
    f_ = (f // f.lc()).change_ring(ZZ)
    f = f.change_ring(ZZ)
    l = f.lm()

    M = []
    for k in range(m+1):
        M_k = set()
        T = set((f ^ (m-k)).monomials())
        for mon in (f^m).monomials():
            if mon//l^k in T:
                for extra in itertools.product(range(d), repeat=f.nvariables()):
                    g = mon * prod(map(power, f.variables(), extra))
                    M_k.add(g)
        M.append(M_k)
    M.append(set())

    shifts = PolynomialSequence([], f.parent())
    for k in range(m+1):
        for mon in M[k] - M[k+1]:
            g = mon//l^k * f_^k * N^(m-k)
            shifts.append(g)

    B, monomials = shifts.coefficient_matrix()
    monomials = vector(monomials)

    factors = [monomial(*bounds) for monomial in monomials]
    for i, factor in enumerate(factors):
        B.rescale_col(i, factor)

    print("LLL...")
    B = B.dense_matrix().LLL()
    print("Done")

    B = B.change_ring(QQ)
    for i, factor in enumerate(factors):
        B.rescale_col(i, 1/factor)
    B = B.change_ring(ZZ)

    H = PolynomialSequence([h for h in B*monomials if not h.is_zero()])
    return solve_system_with_jacobian(H, f, bounds)


e = 0x010001
n = 0x00c0d76392ed01ca0729a8a0aaecbf09ee5814806fb7d0cb4fe97c81a6b48b6fd86eefdeebc71a33305f4b64c5b55b342a9dbc09ba081a2a0293e6e3b09f3f290a8c8f1c08aa28a3c830c58bc5ff97b2dc7b309e576673180ec0f8273099bc9ff84e477ade15279ca2fbc7e2df3e59dd7705e2339ca306141487a7454b6d3e7188dea6530bfee5892c0583c6132c613c0c5c1ed7f0d1a97d306fa666964bf50e11d10b3fe7d54574b815532d763979b6f5625d9823fb7c2186727197ef158bce3e3575267a79baa1819ed1d2de595ebf9ffb909b8df2a8e9efbe73f490a0cd35a4d8f02a7bd3dd5652c9d6902e75e1e9bf75df3a7da23bd7e97350b71546868161d6ab486c610471b80334745c03dac178266b32aff70fd62799f1e8da324db32fbf5b502ee45f9ff263d55f0498cfbc50b77cab263447cfcded4b5cd2ed6302276b6b69b30a4d44232c95dd2f1ae5e993577a591958b4c61ef1a9755d3641b470c127108f0a9fbe715bbc3082fe260afbeb578c229ce511a096ee492955378907
u = 0x67a20eff99da8fd3a85d2ea87d2ff339bde448035e19cb042693608c7e630aa4a71a7c6f66b692a2c1c57169943f90947ff29fcfc3ae1bce6edf1d09600b73a952b2b34fa3d26e2a9adb84df29dda24e982de676e468a50d273c4de535bf8a11503889f339d9428fdee8f07ca7dd89768ab0ee6a72e3829514d0df9d1330be467b7999369d6699b16945a87787ea540fbc828280a23de75e573d0a6d4fb10d526b71e3a55e7b41db39d0bf773609eeaa7cc018e279aca93125c23107568e687e
q_middle = 0xc570613da06c478
q_lower = 0x691738dc8996d
q_upper = 0xc597ff4fc78fabff87fd021ee21d02e2b2f726cbe12

PR.<x0,x1> = PolynomialRing(Zmod(n), 2)
qq = q_upper*2^(4*341) + q_middle*2^(4*116) + q_lower + 2^52*x0 + 2**524*x1
f = u*qq**2 - qq

x0, x1 = coppersmith(f, bounds=(2^412, 2^840), m=3, d=2)
q = int(qq(x0, x1))
assert is_prime(q)
print(f"{q = }")
```

This spits out

```python
q = 1860400960117464949532416004639466629994076821767309538826515112720671132102034738577938121013868915703939452009570308375925288112735480787384780575361241826457665569291257342639256426234197438821880680008965742321854591919619063729626119862840545588909676241323030007484307455645544766439964269237529144790202822411163427130628861671228602354772689245481045576816266142485189200125194387337260813139712001196664255796834077354270127893071327103533571746413713773
```


Now I will contruct a PEM key and convert to openssh format.

```python
from Crypto.PublicKey import RSA

e = 0x010001
n = 0x00c0d76392ed01ca0729a8a0aaecbf09ee5814806fb7d0cb4fe97c81a6b48b6fd86eefdeebc71a33305f4b64c5b55b342a9dbc09ba081a2a0293e6e3b09f3f290a8c8f1c08aa28a3c830c58bc5ff97b2dc7b309e576673180ec0f8273099bc9ff84e477ade15279ca2fbc7e2df3e59dd7705e2339ca306141487a7454b6d3e7188dea6530bfee5892c0583c6132c613c0c5c1ed7f0d1a97d306fa666964bf50e11d10b3fe7d54574b815532d763979b6f5625d9823fb7c2186727197ef158bce3e3575267a79baa1819ed1d2de595ebf9ffb909b8df2a8e9efbe73f490a0cd35a4d8f02a7bd3dd5652c9d6902e75e1e9bf75df3a7da23bd7e97350b71546868161d6ab486c610471b80334745c03dac178266b32aff70fd62799f1e8da324db32fbf5b502ee45f9ff263d55f0498cfbc50b77cab263447cfcded4b5cd2ed6302276b6b69b30a4d44232c95dd2f1ae5e993577a591958b4c61ef1a9755d3641b470c127108f0a9fbe715bbc3082fe260afbeb578c229ce511a096ee492955378907
q = 1860400960117464949532416004639466629994076821767309538826515112720671132102034738577938121013868915703939452009570308375925288112735480787384780575361241826457665569291257342639256426234197438821880680008965742321854591919619063729626119862840545588909676241323030007484307455645544766439964269237529144790202822411163427130628861671228602354772689245481045576816266142485189200125194387337260813139712001196664255796834077354270127893071327103533571746413713773
p = n//q
assert p*q == n
d = pow(e, -1, lcm(p-1,q-1))
key = RSA.construct((n,e,d,p,q)).export_key('PEM')
open('key.pem', 'wb').write(key)
```

```bash
chmod 600 key.pem
ssh-keygen -f key.pem -i -p
diff -y key key.pem
```

The only differing line now is this one (the check-int):

```
???????????????????????????????????????HAAAFeIwxH26MMR9uAAAAB3NzaC1yc2 | EI8Kn75xW7wwgv4mCvvrV4winOURoJbuSSlVN4kHAAAFeGf1DVRn9Q1UAAAAB3NzaC1yc2
```

Replace this with the one in the original key and you are done!

```
05bc9eca84c44570670df15d29a37d78ffe9813073ca41d2147b14a06e9d96a1
```
