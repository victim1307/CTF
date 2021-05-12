## cookin the ramen (50 Points)

### Problem
```
Apparently we made cookin the books too hard, here's some ramen to boil as a warmup:

.--- ...- ...- . ....- ...- ... ..--- .. .-. .-- --. -.-. .-- -.- -.-- -. -... ..--- ..-. -.-. ...- ...-- ..- --. .--- ... ..- .. --.. -.-. .... -- ...- -.- . ..- -- - . -. ...- -. ..-. --- -.-- --.. - .-.. .--- --.. --. --. ...-- ... -.-. -.- ..... .--- ..- --- -. -.- -..- -.- --.. -.- ...- ..- .-- - -.. .--- -... .... ..-. --. --.. -.- -..- .. --.. .-- ...- ... -- ...-- --.- --. ..-. ... .-- --- .--. .--- .....
```

### Solution
Okay, very obviously we have morse code to decode. Running through an online decoder we get:

`JVVE4VS2IRWGCWKYNB2FCV3UGJSUIZCHMVKEUMTENVNFOYZTLJZGG3SCK5JUONKXKZKVUWTDJBHFGZKXIZWVSM3QGFSWOPJ5`

and then giving a quick run through our good friend Magic by CyberChef, we get our flag.

It looks like the algorithm for this challenge was:

Plaintext -> Base58 -> Base64 -> Base32 -> Morse -> Ciphertext



Flag: `DawgCTF{0k@y_r3al_b@by's_f1r5t}`


## Third Eye (75 Points)

### Problem
```
This beat is making me see things that I didn't think I could see...

third_eye.mp3: https://drive.google.com/file/d/13Je41zqYscApr-f6GJ5kC8RjeRP6hjUi/view?usp=sharing

```

### Solution
This is the first Audio challenge I've done! Exciting! The challenge name immediately brought me to the idea of checking out the waveform/spectogram of the linked MP3 file.
I've used Audacity in the past for old university music programming assignments, so I went there first and looked at the waveform and spectogram. I couldn't see anything here, so I went to Google to do some digging.
I came across a John Hammond [video](https://www.youtube.com/watch?v=rAGkm4pv44s&t=261s) on Audio Spectograms. He mentioned using Sonic Visualizer for these type of challenges so I installed it and opened the MP3 file there.

![image](https://user-images.githubusercontent.com/78896740/118043538-20653480-b393-11eb-8e6d-331564d6bf0b.png)

I could see some Hex straight away, so I manually typed them out into a Hex -> ASCII converter and got the flag.


Flag: `DawgCTF{syn3sth3s1acs}`
