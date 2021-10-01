# ***CRYPTOHACKS***

## ***INTRODUCTION***

### *Finding Flag*

The flag is given in the question.

*```FLAG:- crypto{y0ur_f1rst_fl4g)```*

### *Great snakes*

By running the program we get the flag.

*```FLAG:- crypto{z3n_0f_pyth0n}```*

### *Networks Attacks*

We are given a .py file.
If we change buy:clothes to buy:flags and run the program we will get the answer.

*```FLAG:- crypto{sh0pp1ng_f0r_fl4g5}```*

## ***GENERAL***

### *ASCII*

We are given a list of ascii value if we convert them into text we get the flag.

```
ini_list = [99, 114, 121, 112, 116, 111, 123, 65, 83, 67, 73, 73, 95, 112, 114, 49, 110, 116, 52, 98, 108, 51, 125]
res = "" 
for val in ini_list:
      res = res + chr(val)
print ("Resultant string", str(res))
```

using this program we get the flag

*```FLAG:- crypto{ASCII_pr1nt4bl3}```*

### *HEX*

We are given a hex string. To get the flag we should decode from hex. We can use ```.decode('hex')```

Or by this progra we can obtain the flag.
```
x = '63727970746f7b596f755f77696c6c5f62655f776f726b696e675f776974685f6865785f737472696e67735f615f6c6f747d'
byte_array = bytearray.fromhex(x)
print(byte_array)
```
We get the using the code.

*```FLAG:- crypto{You_will_be_working_with_hex_strings_a_lot}```*

### *Base64*

We are given a hex string. First we have to decode from hex.

Now the output of .decode('hex') or the above program we get string in bytes
```'r\xbc\xa9\xb6\x8f\xc1j\xc7\xbe\xeb\x8f\x84\x9d\xca\x1d\x8ax>\x8a\xcf\x96y\xbf\x92i\xf7\xbf'```

By encodeing the bytes using the following program we get the flag.

```
from base64 import b64encode
b64encode(byte_arr)
```

*```FLAG:-crypto/Base+64+Encoding+is+Web+Safe/```*

### *Bytes to Big Integers*

We are given long integers.

By using long_to_bytes , bytes_to_long we convert long integers to bytes and vice versa.

By using the following program we get the flag.
```
>>> from Crypto.Util.number import bytes_to_long, long_to_bytes    
>>> val = 11515195063862318899931685488813747395775516287289682636499965282714637259206269
>>> long_to_bytes(val) 
```

*```FLAG:- crypto{3nc0d1n6_4ll_7h3_w4y_d0wn}```*

### *Encoding Challenge*

We are given a .py file. If we rreach 100th level we will get the flag.

## ***XOR***

### *XOR Starter*

We are given a word. And that word is XORed with 13.
So we conver word in binary then XOR with binary of 13. We get the flag
```
data = "label"
flag = ''
for c in data:
    flag += chr(ord(c) ^ 13)
print(flag)
```
Since the flag mentioned is crypto{string}.

*```FLAG:- crypto{aloha}```*

## *XOR Properties*

We are given
```
>>>KEY1 = a6c8b6733c9b22de7bc0253266a3867df55acde8635e19c73313
>>>KEY2 ^ KEY1 = 37dcb292030faa90d07eec17e3b1c6d8daf94c35d4c9191a5e1e
>>>KEY2 ^ KEY3 = c1545756687e7573db23aa1c3452a098b71a7fbf0fddddde5fc1
>>>FLAG ^ KEY1 ^ KEY3 ^ KEY2 = 04ee9855208a2cd59091d04767ae47963170d1660df7f56f5faf
```
We have to first decode from hex.By using the program we can get the flag coverting into hex.
```
import codecs
k1 = int('a6c8b6733c9b22de7bc0253266a3867df55acde8635e19c73313', 16)
k2_3 = int('c1545756687e7573db23aa1c3452a098b71a7fbf0fddddde5fc1', 16)
flag = int('04ee9855208a2cd59091d04767ae47963170d1660df7f56f5faf',16)
flag = k1 ^ k2_3 ^ flag
print(codecs.decode(('%x' %flag),'hex_codec'))
```
*```FLAG:- crypto{x0r_i5_ass0c1at1v3}```*

### *Favorite Bytes*

We are given a hex,which we have decode.
Then since it is single byte xor the length of the key is 1.
Therefore we can say there will be 256 that we try and xor to get the flag.
By using the the code we can find the flag.
```
import codecs
import pwn
    
x=b'73626960647f6b206821204f21254f7d694f7624662065622127234f726927756d'
x=(codecs.decode(x,"hex"))
for i in range(255):
    msg = (pwn.xor(x,i))
    if ('crypto' in msg.decode("UTF-8")):
        print(msg)
        exit()
```
 
*```FLAG:-crypto{0x10_15_my_f4v0ur173_by7e}```*
