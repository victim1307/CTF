## These Ladies Paved Your Way (150 Points)

### Problem
```
Per womenintech.co.uk, these 10 women paved your way as technologists. One of them holds more than 100 issued patents and is known for writing understandable textbooks about network security protocols. What other secrets does she hold?

file: WomenInTech.zip
```

### Solution
We're given a quick overview on 10 women who are trailblazers in tech and a ZIP file containing 10 JPEGs on, 1 for each of these women. One in particular was mentioned in the problem spec and how she holds more than 100 patents. So I googled this, and found out it was Radia Perlman.
My next step was to run `exiftool` on Perlman's JPEG.

```
❯ exiftool radia_perlman.jpg
ExifTool Version Number         : 12.21
File Name                       : radia_perlman.jpg
Directory                       : .
File Size                       : 10 KiB
...
...
Resolution Unit                 : None
X Resolution                    : 1
Y Resolution                    : 1
Current IPTC Digest             : 8d370a1f7871e76616c0f06987707b84
Credit                          : U3Bhbm5pbmdUcmVlVmlnCg==
Keywords                        : VpwtPBS{r0m5 0W t4x3IB5}
```

Immediately I am suspicious of `Credit` and `Keywords`. I only looked at Vigenère Ciphers before the CTF and one example used a Base64 encoded key haha. I decoded `U3Bhbm5pbmdUcmVlVmlnCg==` to `SpanningTreeVig`, so I plugged that into a Vigenère Cipher solver and out fell the key.


Flag: `DawgCTF{l0t5 0F p4t3NT5}`


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

## The Rain in Spain
I installed this cool IoT-enabled weathervane on my boat for sailing around Málaga, but the sensors seem to be giving erratic readings…

Author: Noodle

Attached: spain.csv

### Solution:
Plot a graph with the given .csv file using https://www.csvplot.com/ and play around with the axes to display the flag nicely.
![image](https://user-images.githubusercontent.com/78896740/118044190-f95b3280-b393-11eb-8051-beb418b6cff9.png)
Flag: `DawgCTF{p10ts_n3at1y_0n_th3_p1an3}`


## Moses(Audio/Radio)
If you can find a way to part the waves, you might find something on the seafloor.

moses.zip: hxxps://drive.google.com/file/d/1c6uEmcRssq2FKmQqNYNJ3NRvK6t_KVAd/view?usp=sharing

Author: Noodle
### Solution:
The .zip file contains moses1.flac and moses2.flac with almost identical spectrograms. This is viewed using Spek.
To find out the difference between these 2 audios, we can do a phase inversion in Audacity.
Import both tracks into Audaciity
Select one track and apply the Invert Effect on it.
Select both tracks and Mix and Render
Export the new track
![image](https://user-images.githubusercontent.com/78896740/118046442-f7df3980-b396-11eb-8561-8255637e05e9.png)
![image](https://user-images.githubusercontent.com/78896740/118046462-fdd51a80-b396-11eb-93dd-8d293daebdb8.png)
![image](https://user-images.githubusercontent.com/78896740/118046474-03cafb80-b397-11eb-8353-7e45c8a3cda2.png)

The flag is now at the bottom of the spectrogram of the new track.
![image](https://user-images.githubusercontent.com/78896740/118046507-0f1e2700-b397-11eb-9cae-3c07ad344fb3.png)

## Deserted Island Toolkit
What would a drunken sailor do? (Wrap the output in DawgCTF{ })

DesertedIslandToolkit.zip: hxxps://drive.google.com/file/d/1vYUIAPIeQgE6x781tH6SU3uU0YSx5Yxv/view?usp=sharing

Author: Eyeclept
### Solution
The .zip contains these standard CD files:
`dawgTunes.cdda
.checksum.md5`
The .cdda file contains audio data so let’s convert it to a listenable format with https://convertio.co/cdda-wav/
The audio is then a series of short and long tones which we can immediately suspect to be Morse Code:
which was transcribed as... ----- ... .. ... -. --- - - .... . .- -. ..... .-- ...-- .-. and decoded to be S0SISNOTTHEAN5W3R
Flag: `DawgCTF{S0SISNOTTHEAN5W3R}`
