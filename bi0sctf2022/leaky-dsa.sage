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
