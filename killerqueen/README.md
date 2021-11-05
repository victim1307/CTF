#

## Challenge Description

![image](https://user-images.githubusercontent.com/56489087/139564545-c730c76d-842a-47df-afb3-19f9a75a76f2.png)


## Files

We're given two files: mystery.txt and key.pub

![image](https://user-images.githubusercontent.com/56489087/139564583-e8e8a757-1cc5-4005-ae3f-e74bb317490a.png)

After analyzing the key with a few online decoders, we know that this is an RSA public key and what appears to be its base64 cipher text.

![image](https://user-images.githubusercontent.com/56489087/139564653-94f42dd3-55ca-4224-8688-5e13562bea59.png)

## Uncipher

Using RsaCtfTool, we can uncipher this text file and get the key.

> ./RsaCtfTool.py --publickey ./key.pub --uncipherfile ./ciphered\_file

![image](https://user-images.githubusercontent.com/56489087/139564756-c205052b-4b90-44fe-885a-e46537032eb2.png)

The results are then spit out in different encodings. We can decode this online to find  the flag.

![image](https://user-images.githubusercontent.com/56489087/139564783-fff092f0-af1d-4c50-a241-f9035d79d66b.png)

## Insight

While resarching what approach I should take with this challenge, I stumbled upon a website that explains RSA well.

![image](https://user-images.githubusercontent.com/56489087/139564847-2d64de00-cff4-4d21-84eb-a5e6d35b6911.png)

http://www.isg.rhul.ac.uk/static/msc/teaching/ic2/demo/42.htm

Reading through this should help.
