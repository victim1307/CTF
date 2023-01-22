from Crypto.Util.number import *
from hashlib import sha256

import itertools

def small_roots(f, bounds, m=1, d=None):
	if not d:
		d = f.degree()

	R = f.base_ring()
	N = R.cardinality()

	f /= f.coefficients().pop(0)
	f = f.change_ring(ZZ)

	G = Sequence([], f.parent())
	for i in range(m+1):
		base = N^(m-i) * f^i
		for shifts in itertools.product(range(d), repeat=f.nvariables()):
			g = base * prod(map(power, f.variables(), shifts))
			G.append(g)

	B, monomials = G.coefficient_matrix()
	monomials = vector(monomials)

	factors = [monomial(*bounds) for monomial in monomials]
	for i, factor in enumerate(factors):
		B.rescale_col(i, factor)

	B = B.dense_matrix().LLL()

	B = B.change_ring(QQ)
	for i, factor in enumerate(factors):
		B.rescale_col(i, 1/factor)

	H = Sequence([], f.parent().change_ring(QQ))
	for h in filter(None, B*monomials):
		H.append(h)
		I = H.ideal()
		if I.dimension() == -1:
			H.pop()
		elif I.dimension() == 0:
			roots = []
			for root in I.variety(ring=ZZ):
				root = tuple(R(root[var]) for var in f.variables())
				roots.append(root)
			return roots

	return []

p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
a = 0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc
b = 0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b

E = EllipticCurve(GF(p), [a,b])
G = E.gens()[0]
q = G.order()

z1, r1, s1, k1 = (67895390162192244186976567361153286902705570334930716600904954353179569739014, 86494490592789367076969564620098800553061820934402886661451271606072368146355, 107525473811743000665289131160046593558370071369288653369028361371002567982203, 58357776889849858751099744934919682808475954590804652472244240458381854244864)
z2, r2, s2, k2 = (26864658293786238469963656558471928520481084212123434372023814007136979246767, 88341198029655895102945100401136791812455017523484470848755408447466479718369, 107658140648544742086174943506076749571003426340592621462111899159870884498827, 10065874497558688688450730957054532854755710436735671677195949146032492773376)

PR.<x, y> = PolynomialRing(Zmod(q), 2)
f = (s1*(k1+x)-z1) * pow(r1, -1, q) - (s2*(k2+y)-z2) * pow(r2, -1, q)
x, y = small_roots(f, bounds=(2**120, 2**120), m=1, d=4)[0]

priv = (s1*(k1+x)-z1) * pow(r1, -1, q) % q
print(long_to_bytes(int(priv)))
➜  exploit git:(main) ✗ cd ../../../
➜  bioschalls cd bad2code/admin/exploit
➜  exploit git:(main) ✗ ls
ct.txt         solver.sage    solver.sage.py
➜  exploit git:(main) ✗ cat solver.sage
#solve script for the challenge
# implementing Merkle–Hellman knapsack cryptosystem
from Crypto.Util.number import *
import fpylll
FLAG_FORMAT = "bi0s"


FLAG_FORMAT = "bi0s"

NBITS = 44<<2

a = 0xBAD2C0DE
c = 0x6969
m = 1<<NBITS

public = [1]
for i in range(2, 91):
    public.append(public[-1]*i)
q = sum(public)

ct = eval(open('ct.txt').read())

public = [1]
for i in range(2, 91):
    public.append(public[-1]*i)
q = sum(public)
r = 439336960671443073145803863477

B = [r*i % q for i in public]

def decrypt(ct):
    r_inv = inverse(r, q)
    ct_inv = ct*r_inv % q
    lst = []
    while True:
        for i in range(len(public)-1, -1, -1):
            if ct_inv >= public[i]:
                ct_inv -= public[i]
                lst.append(i)
                break
        if ct_inv == 0:
            break
    d = {}
    for i in lst:
        if i in d:
            d[i] += 1
        else:
            d[i] = 1
    cct = 0
    # first item in the dict
    m = max(lst)
    for i, j in d.items():
        cct += 2**(m-i)*j
    return cct

ptlist = []
for i,j in ct:
    i = int(i)
    j = Integer(j)
    pt = decrypt(j)
    if pt.nbits() < i:
        pt = pt << (i-pt.nbits())
    ptlist.append(pt)

#Applying LCG on ptlist:
#load('solvelinmod.py')
def solve_linear_mod(equations, bounds, guesses=None):
    vars = list(bounds)
    if guesses is None:
        guesses = {}

    NR = len(equations)
    NV = len(vars)
    B = fpylll.IntegerMatrix(NR+NV, NR+NV)
    Y = [None] * (NR + NV)
    nS = 1
    for var in vars:
        nS = max(nS, int(bounds[var]).bit_length())
    S = (1 << (nS + (NR + NV + 1)))
    scales = {}
    for vi, var in enumerate(vars):
        scale = S >> (int(bounds[var]).bit_length())
        scales[var] = scale
        B[NR + vi, vi] = scale
        Y[NR + vi] = guesses.get(var, int(bounds[var]) >> 1) * scale
    for ri, (rel, m) in enumerate(equations):
        op = rel.operator()
        if op is not operator.eq:
            raise TypeError('relation %s: not an equality relation' % rel)

        expr = (rel - rel.rhs()).lhs().expand()
        for var in expr.variables():
            if var not in bounds:
                raise ValueError('relation %s: variable %s is not bounded' % (rel, var))
        coeffs = []
        for vi, var in enumerate(vars):
            if expr.degree(var) >= 2:
                raise ValueError('relation %s: equation is not linear in %s' % (rel, var))
            coeff = expr.coefficient(var)
            if not coeff.is_constant():
                raise ValueError('relation %s: coefficient of %s is not constant (equation is not linear)' % (rel, var))
            if not coeff.is_integer():
                raise ValueError('relation %s: coefficient of %s is not an integer' % (rel, var))

            B[ri, vi] = (int(coeff) % m) * S
        B[ri, NV + ri] = m * S

        const = expr.subs({var: 0 for var in vars})
        if not const.is_constant():
            raise ValueError('relation %s: failed to extract constant' % rel)
        if not const.is_integer():
            raise ValueError('relation %s: constant is not integer' % rel)
        Y[ri] = (int(-const) % m) * S
    Bt = B.transpose()
    lll = fpylll.LLL.reduction(Bt)
    result = fpylll.CVP.closest_vector(Bt, Y)
    if list(map(int, result[:NR])) != list(map(int, Y[:NR])):
        raise ValueError("CVP returned an incorrect result: input %s, output %s (try increasing your bounds?)" % (Y, result))

    res = {}
    for vi, var in enumerate(vars):
        aa = result[NR + vi] // scales[var]
        bb = result[NR + vi] % scales[var]
        if bb:
            warnings.warn("CVP returned suspicious result: %s=%d is not scaled correctly (try adjusting your bounds?)" % (var, result[NR + vi]))
        res[var] = aa

    return res

ciphertext = ptlist
equations = []
s = var('s')
ks = [var(f"k{i}") for i in range(len(FLAG_FORMAT))]
bounds = {k: 2**88 for k in ks}
bounds[s] = 2**176

for i, (l, k) in enumerate(zip(FLAG_FORMAT, ks)):
    s = (s*a+c)
    equations.append(((ciphertext[i] ^^ i ^^ ord(l)) << 88 == s - k, m))

s = var('s')
seed = solve_linear_mod(equations, bounds)[s]
print("recovered seed =", seed)

plaintext = []
state = seed
for i, f in enumerate(ciphertext):
    state = (state*a+c) % m
    plaintext.append(chr((state >> (NBITS >> 1)) ^^ i ^^ f))
print("".join(plaintext))
