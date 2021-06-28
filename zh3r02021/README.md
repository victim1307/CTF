```py
from pwn import *
from math import log

host, port = "crypto.zh3r0.cf", 1111

r = remote(host, port)
r.send("")
# Level 0
def level0(passed):
	print("Level 0")
	if not passed:
		r.recvuntil("Level: 1, encrypted flag: ")
		ef1 = r.recvline().decode()[:-1]
		r.recvuntil(">>> ")
		f1 = ""
		for i in range(0, len(ef1), 2):
			byte = int(ef1[i:i + 2], 16)
			byte -= 1
			f1 += hex(byte)[2:]
		print(f1)
		assert len(f1) == len(ef1)
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f1)
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("68656c6c6f20776f726c6421204c6574732067657420676f696e67")


# Level 1
def level1(passed):
	print("Level 1")
	if not passed:
		r.recvuntil("Level: 1, encrypted flag: ")
		ef1 = r.recvline().decode()[:-1]
		r.recvuntil(">>> ")
		f1 = hex(int(ef1))[2:]
		print(f1)
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f1)
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("4e6f7468696e672066616e63792c206a757374207374616e646172642062797465735f746f5f696e74")

# Level 2
def level2(passed):
	print("Level 2")
	if not passed:
		r.recvuntil("Level: 2, encrypted flag: ")
		ef2 = r.recvline().decode()[:-1]
		table = [""]*256
		for i in range(256):
			r.recvuntil(">>> ")
			r.sendline("1")
			r.recvuntil("message in hex:")
			r.sendline(hex(i)[2:].zfill(2))
			key = int(r.recvline().decode()[:-1], 16)
			table[key] = hex(i)[2:].zfill(2)
			print(i)
		f2 = ""
		for i in range(0, len(ef2), 2):
			f2 += table[int(ef2[i:i + 2], 16)]
		assert len(f2) == len(ef2)
		print(f2)
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f2)
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("6d6f6e6f20737562737469747574696f6e73206172656e742074686174206372656174697665")

# Level 3
def level3(passed):
	print("Level 3")
	if not passed:
		r.recvuntil("Level: 3, encrypted flag: ")
		ef3 = r.recvline().decode()[:-1]
		f3 = ""
		for i in range(0, len(ef3), 2):
			byte = ef3[i:i + 2]
			buff = "00" * (i // 2)
			for j in range(256):
				r.recvuntil(">>> ")
				r.sendline("1")
				r.recvuntil("message in hex:")
				r.sendline(buff + hex(j)[2:].zfill(2))
				target = r.recvline().decode()[:-1][-2:]
				if target == byte:
					f3 += hex(j)[2:].zfill(2)
					break
			print(i)
			print("flag so far: ", f3)
		assert len(f3) == len(ef3)
		print(f3)
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f3)
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("6372656174696e6720646966666572656e7420737562737469747574696f6e7320666f7220656163682063686172")

# Level 4
def level4(passed):
	print("Level 4")
	if not passed:
		r.recvuntil("Level: 4, encrypted flag: ")
		ef4 = r.recvline().decode()[:-1]
		f4 = ""
		table = {}
		for n in range(256):
			for i in range(3):
				r.recvuntil(">>> ")
				r.sendline("1")
				r.recvuntil("message in hex:")
				r.sendline(hex(n)[2:].zfill(2) * 512)
				res = r.recvline().decode()[:-1]
				for j in range(0, len(res), 4):
					block = res[j:j + 4]
					if block not in table:
						table[block] = hex(n)[2:].zfill(2)
		for i in range(0, len(ef4), 4):
			block = ef4[i:i + 4]
			f4 += table[block]
		print(f4)
		assert len(f4) == len(ef4) // 2
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f4)
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("476c6164207468617420796f752066696775726564206f75742074686520696e76617269616e74")

# Level 5
def level5(passed):
	print("Level 5")
	if not passed:
		r.recvuntil("Level: 5, encrypted flag: ")
		ef5 = r.recvline().decode()[:-1]
		f5 = ""
		base = ef5[-10:]
		for i in range(0, len(ef5) - 10, 10):
			block = ef5[i:i + 10]
			for j in range(0, len(block), 2):
				diff = int(base[j:j + 2], 16) ^ int(block[j:j + 2], 16)
				if diff in range(32, 128):
					f5 += hex(diff)[2:].zfill(2)
				else:
					break
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f5)
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("4865726520776520617070656e6420746865206b6579207769746820796f757220736869742c20706c6561736520646f6e742074656c6c20616e796f6e65")

# Level 6
def level6(passed):
	print("Level 6")
	if not passed:
		r.recvuntil("Level: 6, encrypted flag: ")
		ef6= int(r.recvline().decode()[:-1])
		print(ef6)
		pay = "10"
		payint = int(pay, 16)
		r.recvuntil(">>> ")
		r.sendline("1")
		r.recvuntil("message in hex:")
		r.sendline(pay)
		res = r.recvline()[:-1].decode()
		while payint**3 == int(res):
			pay += "00"
			r.recvuntil(">>> ")
			r.sendline("1")
			r.recvuntil("message in hex:")
			r.sendline(pay)
			res = r.recvline()[:-1].decode()
			payint = int(pay, 16)
		mod = payint**3 - int(res)
		print(mod)
		# factor mod to get the prime(assume it was a prime modulo), then use sage nth_root to calculate root
		f6 = input("gimme the flag in hex> ")
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f6)
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("43756265206d6f64756c6f207072696d652c20616e7920677565737365732077686174206d6967687420626520636f6d696e67206e6578743f")

# Level 7
def level7(passed):
	print("Level 7")
	if not passed:
		r.recvuntil("Level: 7, encrypted flag: ")
		ef7 = int(r.recvline().decode()[:-1])
		print(ef7)
		r.recvuntil(">>> ")
		r.sendline("1")
		r.recvuntil("message in hex:")
		r.sendline("02")
		power = int(log(int(r.recvline()[:-1].decode()), 2))
		print(power)
		pay = 256
		r.recvuntil(">>> ")
		r.sendline("1")
		r.recvuntil("message in hex:")
		r.sendline("0" + hex(pay)[2:])
		res = r.recvline()[:-1].decode()
		while pay**power == int(res):
			pay = int(1.1 * pay)
			r.recvuntil(">>> ")
			r.sendline("1")
			r.recvuntil("message in hex:")
			payload = hex(pay)[2:]
			if len(payload) % 2:
				r.sendline("0" + payload)
			else:
				r.sendline(payload)
			res = r.recvline()[:-1].decode()
		mod = pay**power - int(res)
		print(mod)
		# factor mod to get the prime(assume it was a prime modulo), then use sage nth_root to calculate root
		f7 = input("gimme the flag in hex> ")
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline(f7) # got the flag
	else:
		r.recvuntil(">>> ")
		r.sendline("2")
		r.recvuntil("flag in hex:")
		r.sendline("7a683372307b31375f61316e375f6d7563685f6275375f315f346d5f73306d333768316e675f30665f345f6372797037346e346c7935375f6d7935336c667d")

level0(True)
level1(True)
level2(True)
level3(True)
level4(True)
level5(True)
level6(True)
level7(True)
r.interactive()
```
