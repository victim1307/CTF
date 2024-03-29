from hashlib import md5
from Crypto.Util.number import long_to_bytes, bytes_to_long
from sage.all import *

class IIter:
    def __init__(self, m, n):
        self.m = m
        self.n = n
        self.arr = [0 for _ in range(n)]
        self.sum = 0
        self.stop = False

    def __iter__(self):
        return self

    def __next__(self):
        if self.stop:
            raise StopIteration
        ret = tuple(self.arr)
        self.stop = True
        for i in range(self.n - 1, -1, -1):
            if self.sum == self.m or self.arr[i] == self.m:
                self.sum -= self.arr[i]
                self.arr[i] = 0
                continue

            self.arr[i] += 1
            self.sum += 1
            self.stop = False
            break
        return ret

def coppersmith(f, bounds, m=1, t=1):
    n = f.nvariables()
    N = f.base_ring().cardinality()
    f /= f.coefficients().pop(0) #monic
    f = f.change_ring(ZZ)
    x = f.parent().objgens()[1]

    g = []
    monomials = []
    Xmul = []
    for ii in IIter(m, n):
        k = ii[0]
        g_tmp = f**k * N**max(t-k, 0)
        monomial = x[0]**k
        Xmul_tmp = bounds[0]**k
        for j in range(1, n):
            g_tmp *= x[j]**ii[j]
            monomial *= x[j]**ii[j]
            Xmul_tmp *= bounds[j]**ii[j]
        g.append(g_tmp)
        monomials.append(monomial)
        Xmul.append(Xmul_tmp)

    B = Matrix(ZZ, len(g), len(g))
    for i in range(B.nrows()):
        for j in range(i + 1):
            if j == 0:
                B[i,j] = g[i].constant_coefficient()
            else:
                v = g[i].monomial_coefficient(monomials[j])
                B[i,j] = v * Xmul[j]

    print("LLL...")
    B = B.LLL(algorithm='NTL:LLL_XD')
    print("LLL finished")

    ###############################################

    print("polynomial reconstruction...")

    h = []
    for i in range(B.nrows()):
        h_tmp = 0
        for j in range(B.ncols()):
            if j == 0:
                h_tmp += B[i, j]
            else:
                assert B[i,j] % Xmul[j] == 0
                v = ZZ(B[i,j] // Xmul[j])
                h_tmp += v * monomials[j]
        h.append(h_tmp)

    x_ = [ var(f'x{i}') for i in range(n) ]
    for ii in Combinations(range(len(h)), k=n):
        f = symbolic_expression([ h[i](x) for i in ii ]).function(x_)
        jac = jacobian(f, x_)
        v = vector([ t // 2 for t in bounds ])
        for _ in range(100): #1000
            kwargs = {f'x{i}': v[i] for i in range(n)}
            tmp = v - jac(**kwargs).inverse() * f(**kwargs)
            v = vector(float(d) for d in tmp)
        v = [ int(_.round()) for _ in v ]
        if h[0](v) == 0:
            return v

    return []

N = 0xb4a8f1786f16b0ad10a2b5c4fdb020a192e963cf61eb3adb6eb55c41c41430a7313c158164b717516ae1f11e8f7b2df85b0d1843a519fd016894623384781eeed8e75f9bd38608d3fa734190ccde2b454e7de484b1600872b4fad839265656067b003c3f33c77345e8f55aa33234ac1b1e4d83d2f487ea1a042d4bdea3748bd3

_p  = "e078e75b3313660ec08eefcdfe98ca82ecea4f3483ce9055?????????05fa57d82f??????????525966d8eca5d968b96ca03e60f1b0a13cbd??????????ac39b"

c = 0
l = []
b = 0
bounds = []
for i, h in enumerate(_p.split("?")[::-1]):
    if h != '':
        bounds.append(2**b)
        b = 4
        c += len(h)*4
        l.append(c)
    else:
        b += 4
    c += 4
l = l[:-1]
bounds = bounds[1:]
xs = [f"x{i}" for i in range(len(l))]
PR = PolynomialRing(Zmod(N), len(l), xs)
f = int(_p.replace("?", "0"), 16) + sum([2**i * PR.objgens()[1][n] for n, (i, x) in enumerate(zip(l, xs))])

roots = coppersmith(f, bounds, m=6)
print(roots)
# replaace roots with question marks
p1 = 0xe078e75b3313660ec08eefcdfe98ca82ecea4f3483ce90559b4a7569505fa57d82f98805c4f60525966d8eca5d968b96ca03e60f1b0a13cbdfe9fb5fa60ac39b
p2 = N // p1


m1 = b'I have written these words in code, made only for Your eyes. Please take them, and read them right away!'
m2 = b'Angling may be said to be so like the mathematics, that it can never be fully learnt.'
m3 = b'sterkte met hierdie hoender kak uitdaging!aaaaaaaa'
m4 = b'asdf'

h1 = bytes_to_long(md5(m1).digest())
h2 = bytes_to_long(md5(m2).digest())
h3 = bytes_to_long(md5(m3).digest())

def ec_attack(e1r1, e1s1, e1r2, e1s2, e1r3, e1s3,p,a,b,G,q):
    E = EllipticCurve(GF(p), [a,b])
    sigs = [
        (h1, e1r1, e1s1),
        (h2, e1r2, e1s2),
        (h3, e1r3, e1s3),
    ]


    B = 2**128

    def construct_lattice():
        basis = []
        for i in range(len(sigs)):
            v = [0]*(len(sigs)+2)
            v[i] = q
            basis.append(v)
        vt = [0]*(len(sigs) + 2)
        va = [0]*(len(sigs) + 2)
        vt[-2] = B/q
        va[-1] = B

        i = 0
        for h, r, s in sigs:
            sinv = pow(s, -1, q)
            vt[i] = int(sinv*r)
            va[i] = int(sinv*h)
            i += 1
        basis.append(vt)
        basis.append(va)
        return Matrix(QQ, basis)

    def attack(sigs):
        M = construct_lattice()
        sol = M.LLL()[1]
        x = [(sigs[i][2]*Mod(k, q) - sigs[i][0])*pow(sigs[i][1], -1, q) for i, k in enumerate(sol[:-2])]
        assert all([xi == x[0] for xi in x])
        return x[0]

    d = attack(sigs)
    print(long_to_bytes(int(d)))


e1r1, e1s1 = (1612267672673999269728546269889722508979219584803720086772336771266932494968854882163090746827783867010928478441725574578434798185148836520222793357664409, 3029861663999386763919329263408950210526667769774548661177259628120473655735835819883693047683687634477510251212674279020595339872463787059444672763866043)
e1r2, e1s2 =  (6920937607492308492531026426883237948115687055299452023010486443862349742662374518108151488895225307077104007635950408052935249793893961606888344967457425, 5742422656545105701912697701170806461172685352973014227993606412238025778233020411208924922864057193231079728252081286980829578488213008308521754040201036)
e1r3, e1s3 = (11524689536002284450998171037036307054742846277802675742949172556232335321396448225382932944277772094535914502482320901822461371660584234934895721193184435, 6893214607636324159131332501962216441800227334291144317058871551673750943026071263237576149193778902782810693078837541653729788537153168679121426068181501)

e2r1, e2s1 =  (9310847431931056244049359037547041054985183713651683407898023670000471901242714582258514259266881645684667996033182832694703927397613640817795368593180756, 10617852808557488415013895570750957460373174370864162956704047722839755596272930959871063929859064252407499346731511780472777650107718002900244279531920783)
e2r2, e2s2 =  (1591504000075936484648853465187400617323242318373302294276214936434682365681931664009334667488054877062343436896587192510208563402894530174245505924438664, 10551673404337663951631437797226273419506279923683925401813338557340284419242113923915109860766456050671758142067004851821533852971341013209167120722344206)
e2r3, e2s3 = (4307246188621120700940993951432665400353791918431733422547827771840952491850352754396324438710747178859567514926315725314445468311066920067664835307739850, 8534539417370444808110288606837181752038745953474385195829799218790205624498166383493367293383265662412103696302517810228606174809985352254953530934195385)

a1 = 0x56fa7ac8a0c5710e0dce1057aa9a33d56a86c403a3a6c39bdd5a463744da4b5b3b29131e055661d2bf76b54793a27702981019f3f6664cc0cdcbe8da6fa1eeb
b1 = 0x7fc41ac9f450cc297109510e5bdab558d25b7e3bf8f8a8ef91bd0c9d985e5aa63f5364bc0bb3e4aa5f9c65780c6a7e633881daee64a1337f42a8c9d56c1ea3d1
a2 = 0x994df157f4e0aee044e654a2cbf8154d605c485268fe0ce660a28d3f474b88c598cc14b5bb199f39e97ea5dcedaad3540f472f690c7fb37895f405cb8a616b3
b2= 0x18a94e4e31772e6893c73126196a91ebdee28b27289665b5ace04106e380d5618fce0003f543bb2f2dacf1ab249a8ed5bf990128b76664dfb9dc316ba1a31802

g1 = 2013900655880801394301932124541532957055873092184807974244791201173073873430583423201811343848166837511621243766087891082508992352198637601420395625191527
g2 = 9133643327953235299057835301736694905103266155388717552464057338789621564626214137183651462439552354223717069640511352515215754704110615697102812193902133

o1 = 11756567260683217973317821468013902925071857221209186747934466797087880003950056062657934676411779626195749253116443260159222430077031406604031496483294819
o2 = 10790881175634558072269092254265802368362184550725174949593446030728701377842120947468767689818768068635638355158161266058040366019788593081905254490911663


de1 = ec_attack(e1r1, e1s1, e1r2, e1s2, e1r3, e1s3,int(p1),a1,b1,g1,o1)
de2 = ec_attack(e2r1, e2s1, e2r2, e2s2, e2r3, e2s3,int(p2),a2,b2,g2,o2)
