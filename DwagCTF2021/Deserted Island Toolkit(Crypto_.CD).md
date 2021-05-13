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
which was transcribed as `... ----- ... .. ... -. --- - - .... . .- -. ..... .-- ...-- .-.` and decoded to be S0SISNOTTHEAN5W3R

Flag: `DawgCTF{S0SISNOTTHEAN5W3R}`
