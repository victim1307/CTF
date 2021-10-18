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

### You either know, XOR you don't
Here i know the starting plain text as "crypto{". Form there i did XOR and found key as myXORke+y
so i assumed it to be myXORkey
```
message = bytes.fromhex("0e0b213f26041e480b26217f27342e175d0e070a3c5b103e2526217f27342e175d0e077e263451150104")
partial_key = "myXORkey"
complete_key = (partial_key * (len(message)//len(partial_key)+1))[:len(message)]

flag = xor(message,complete_key)
print(flag)
```
*```crypto{1f_y0u_Kn0w_En0uGH_y0u_Kn0w_1t_4ll}```*

### Lemur XOR
searched how to xor images and found a tool gmic
```gmic flag.png lemur.png -blend xor -o result.png```
in that image we have the flag
![image](https://user-images.githubusercontent.com/78896740/135693634-235e8d2b-cb6f-413b-8244-8ce7f2ffbea8.png)

*```crypto{X0Rly_n0t!}```*

## *MATHEMATICS*

### *Greatest Common Divisor*
```
import math
p = 81
q = 57
print(math.gcd(p,q))
```
The answer is *```1512```*

### *Extended GCD*

```
import math
p = 26513
q = 32321

def egcd(a, b):
    if a == 0:
        return b, 0, 1
    else:
        gcd, x, y = egcd(b % a, a)
        return gcd, y - (b // a) * x, x
 
 
if __name__ == '__main__':
 
    gcd, x, y = egcd(p, q)
    print("The GCD is", gcd)
    print(f"x = {x}, y = {y}")
```
The answer is *```-8404```*

## *DATA FORMATS*
### *Privacy-Enhanced Mail?*
here we are given a RSA .pem file. I just know we need to decode it and extract the the info hidden
luckily i found this website : http://certificate.fyicenter.com/2145_FYIcenter_Public_Private_Key_Decoder_and_Viewer.html#Result

![image](https://user-images.githubusercontent.com/78896740/135708500-5a8baa73-4e1e-4137-a508-e57db9c0cf87.png)

it gave all the values and i even found "d" there but in hex so i decoded it using python
![image](https://user-images.githubusercontent.com/78896740/135708518-f2ff635e-9d4b-4225-9ced-7cd7fdf9a52b.png)

and got d in decimal *```d: 15682700288056331364787171045819973654991149949197959929860861228180021707316851924456205543665565810892674190059831330231436970914474774562714945620519144389785158908994181951348846017432506464163564960993784254153395406799101314760033445065193429592512349952020982932218524462341002102063435489318813316464511621736943938440710470694912336237680219746204595128959161800595216366237538296447335375818871952520026993102148328897083547184286493241191505953601668858941129790966909236941127851370202421135897091086763569884760099112291072056970636380417349019579768748054760104838790424708988260443926906673795975104689```*

### CERTainly not
we are given .der certificate. we need t decode it. After some googling i found this page:
https://www.ssl.com/guide/pem-der-crt-and-cer-x-509-encodings-and-conversions/

here they gave terminal commands to view the der certificates
```openssl x509 -inform der -in CERTIFICATE.der -text -noout```
this command helps to view the content on the der certificate.
![image](https://user-images.githubusercontent.com/78896740/135710070-66aca271-6e0d-48c6-b147-f3ace63dda0f.png)

from that image i found Modulus but in hex encoded, decoded it using python.
![image](https://user-images.githubusercontent.com/78896740/135710090-0626ded5-f397-44d1-8378-ba7309a58eea.png)

So theModulus is : *```22825373692019530804306212864609512775374171823993708516509897631547513634635856375624003737068034549047677999310941837454378829351398302382629658264078775456838626207507725494030600516872852306191255492926495965536379271875310457319107936020730050476235278671528265817571433919561175665096171189758406136453987966255236963782666066962654678464950075923060327358691356632908606498231755963567382339010985222623205586923466405809217426670333410014429905146941652293366212903733630083016398810887356019977409467374742266276267137547021576874204809506045914964491063393800499167416471949021995447722415959979785959569497```*

## *MODULAR MATH*

### *Quadratic Residues*
just cecked which one has a Quadratic Residues in that list and printed the smallest one.
```
for i in range(1,100):
        if (((i**2)%29 == 11) or ((i**2)%29 == 6) or ((i**2)%29 == 14)):
                print(i)
                break
```

### *Legendre Symbol*


## RSA
![image](https://user-images.githubusercontent.com/78896740/137736837-f03d7bb4-4c96-4d79-97a2-05a7f61acfb6.png)

![image](https://user-images.githubusercontent.com/78896740/137736899-79f8ebbe-e901-44c0-9f43-553ff38080cb.png)

website : https://www.educative.io/edpresso/what-is-the-rsa-algorithm

### *RSA Starter 1*
![image](https://user-images.githubusercontent.com/78896740/137734401-46ac909d-9b24-4c49-90ff-c9e4f2196299.png)


### *RSA Starter 2*
![image](https://user-images.githubusercontent.com/78896740/137734486-99ecfac2-eb35-4af8-9ae5-ba19aede78ba.png)


### *RSA Starter 3*
![image](https://user-images.githubusercontent.com/78896740/137734597-ce5c628a-585c-45b2-a174-9964cfa1bf11.png)

### *RSA Starter 4*
Finding out d:
![image](https://user-images.githubusercontent.com/78896740/137736605-bc9f2dd6-3c9c-4e6a-ab4d-2c3ffe2b4b41.png)

modular inverse: pow(e,-1,tot)

### *RSA Starter 5*
![image](https://user-images.githubusercontent.com/78896740/137737911-6ca2340f-2eb4-43a8-b032-286967a4ad6e.png)

### *RSA Starter 6*
![image](https://user-images.githubusercontent.com/78896740/137742598-8fd7123a-caaa-4652-a2fe-a285be1728b4.png)

## *PRIME PART 1*

### FACTORING
![image](https://user-images.githubusercontent.com/78896740/137743374-956c8ca0-7d3a-43ab-9960-a0d0f77aad76.png)

### Inferius Prime
![image](https://user-images.githubusercontent.com/78896740/137743750-43ea5de8-1a48-4e3c-bc11-ab5fb06e92a6.png)

### MONOPRIME
![image](https://user-images.githubusercontent.com/78896740/137773300-d2afeebd-8537-4cf4-a389-4a90973b03dd.png)

### Square Eyes

### Manyprime

I factorised the numbers using factordb and used it directly Manyprime

```py
from Crypto.Util.number import long_to_bytes
lst = [9282105380008121879,9303850685953812323,9389357739583927789,10336650220878499841,10638241655447339831,11282698189561966721,11328768673634243077,11403460639036243901,11473665579512371723,11492065299277279799,11530534813954192171,11665347949879312361,12132158321859677597,12834461276877415051,12955403765595949597,12973972336777979701,13099895578757581201,13572286589428162097,14100640260554622013,14178869592193599187,14278240802299816541,14523070016044624039,14963354250199553339,15364597561881860737,15669758663523555763,15824122791679574573,15998365463074268941,16656402470578844539,16898740504023346457,17138336856793050757,17174065872156629921,17281246625998849649]

n = 580642391898843192929563856870897799650883152718761762932292482252152591279871421569162037190419036435041797739880389529593674485555792234900969402019055601781662044515999210032698275981631376651117318677368742867687180140048715627160641771118040372573575479330830092989800730105573700557717146251860588802509310534792310748898504394966263819959963273509119791037525504422606634640173277598774814099540555569257179715908642917355365791447508751401889724095964924513196281345665480688029639999472649549163147599540142367575413885729653166517595719991872223011969856259344396899748662101941230745601719730556631637

pi =1

e = 65537

ct = 320721490534624434149993723527322977960556510750628354856260732098109692581338409999983376131354918370047625150454728718467998870322344980985635149656977787964380651868131740312053755501594999166365821315043312308622388016666802478485476059625888033017198083472976011719998333985531756978678758897472845358167730221506573817798467100023754709109274265835201757369829744113233607359526441007577850111228850004361838028842815813724076511058179239339760639518034583306154826603816927757236549096339501503316601078891287408682099750164720032975016814187899399273719181407940397071512493967454225665490162619270814464


for i in range(len(lst)):
	pi = pi*(lst[i]-1)

d = pow(e,-1,pi)

p = pow(ct , d, n)
print(long_to_bytes(p))
```

## PUBLIC EXPONENT

### Salty
if e=1 then ct = pt
![image](https://user-images.githubusercontent.com/78896740/137785689-93527db1-0279-43a5-82c8-c1c070e795be.png)

### Modulus Inutilis

Small e attack

![image](https://user-images.githubusercontent.com/78896740/137785980-bc1d26c9-8f23-4379-a941-dab990812043.png)
