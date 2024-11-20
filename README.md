# How to make it work
You need [Powershell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4) installed, as well as [ffmpeg](https://www.ffmpeg.org/) in your PATH.

## Folder structure
You need a these things in a folder:
- The raw video clips. I record at 3 FPS, because it gets sped up 20 times to 60 FPS. No need to record any faster, the frames would be dropped anyway.
- The music you want to use, in `.wav`
- A file named `soustitres.json` that has the credit to the music you used
  - This file is json formatted, with the following structure. You can put anything inbetween the quotes, as long as it's a legal string.
```json
{
  "Titles": {
    "1": "Romeo and Juliet - Masks",
    "2": "The Nutcracker - Dance of the Mirlitons",
    "3": "The Nutcracker - Russian Dance",
    "4": "Carmen - Les tringles des sistres tintaient"
  },
  "Artists": {
    "1": "Prokofiev S.",
    "2": "Tchaikovsky P. I.",
    "3": "Tchaikovsky P. I.",
    "4": "Bizet G."
  }
}

```
On top of that, you need an image to put at the end of the video. It doesn't have to be in the folder.

Then to actually edit the damn thing
```batch
cd "C:\Path\to\this\repository"
"C:\Program Files\PowerShell\7\pwsh.exe" -NoProfile -ExecutionPolicy Bypass -Command "& '.\editing.ps1' -image '<path to the image you want to have scroll at the end .png>' -videoFolder '<path to the folder with all the things>'"
```
For example

```batch
cd "C:\Users\bob\Documents\Github\ffmpeg-timelapses"
"C:\Program Files\PowerShell\7\pwsh.exe" -NoProfile -ExecutionPolicy Bypass -Command "& '.\editing.ps1' -image 'C:\Users\bob\Documents\best-girl.png' -videoFolder 'E:\timelapses\2024-11-18'"
```

The output file will be in a subfolder named `out`, in the repository folder

## Notes
- Comments are a mess of English and French. I didn't think I'd ever release it, so I wrote it the way it made sense to me to read it.
- There is a section commented out at the end of `editing.ps1` to reencode the video to VP9, for web hosting purposes.
