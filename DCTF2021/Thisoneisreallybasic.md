## This one is really basic (Crypto)
The answer to life, the universe, and everything.
file: https://dctf.dragonsec.si/files/51555fa45bd2a8345dec6914ad89f3a8/cipher.txt

## Solution:
```py
import base64
cipher = ""
with open('cipher.txt', 'r') as f:
    cipher = f.readlines()

real_cipher = cipher[0].strip()

for i in range(42):
    real_cipher = base64.b64decode(real_cipher).decode()

print(real_cipher)
```

Flag : `dctf{Th1s_l00ks_4_lot_sm4ll3r_th4n_1t_d1d}`
