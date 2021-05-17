## Powerpoint programming
A login page in powerpoint should be good enough, right?
Flag is not in format. DCTF{ALL_CAPS_LETTERS_OR_NUMBERS}
file:https://dctf.dragonsec.si/files/f34498994fc9cdf2752a5019c37a7b0b/chall.ppsx

## Solution:
Initially i tried to open oit directly but the complete screec looks like some lockscreen page where there is keys and if we type the flag it gives correct or not.
So next thing I did is to open the file in the PowerPoint. And it looks good now because now the screen isn't locked it like a editable ppsx.

![image](https://user-images.githubusercontent.com/78896740/118482768-d1245880-b732-11eb-8dc6-ede9653434c4.png)

And now I opened the Animation plane to see the exact animation where we get the slide correct. In Animation there are many triggers and all dores the same job.(triggres after 86)

![image](https://user-images.githubusercontent.com/78896740/118482931-0761d800-b733-11eb-8be1-cf90f5666645.png)

And I started pressing them manually and noted the flag.
 flag : `DCTF {PPT_1SNT_V3RY_S3CUR3_1S_1T}`
