import codecs
import pwn
    
x=b'73626960647f6b206821204f21254f7d694f7624662065622127234f726927756d'
x=(codecs.decode(x,"hex"))
for i in range(255):
    msg = (pwn.xor(x,i))
    if ('crypto' in msg.decode("UTF-8")):
        print(msg)
        exit()
    
