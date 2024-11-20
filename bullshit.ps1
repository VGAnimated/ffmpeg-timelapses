function generateTextBlurb {
    <#
        .SYNOPSIS
            Creates the titles to display on screen when the music changes

        .DESCRIPTION
            The subtitles are composed of the name of the music and its composer. They will both be displayed on the bottom left. The artist will be under the title, in a smaller font size, both aligned to the left.
            It will generate the text, style it in a font, give it a shadow, a colour, a border and most importantly time it correctly based on the duration of the music files in config/audios.txt

        .PARAMETER startTS
            The TimeStamp at which the title should Start in the video

        .PARAMETER title
            The title of the music

        .PARAMETER artist
            The composer of the music

        .EXAMPLE
            generateTextBlurb -startTS 4 -title "Never gonna give you up" -artist "Rick Astley"

    #>
    param ($startTS, $title, $artist)

    $filterTitle = "drawtext=
    text=${title}
    :shadowx=4
    :shadowy=3
    :shadowcolor=black@0.35
    :borderw=2
    :bordercolor=black@0.25
    :fontfile=/Users/pixel/AppData/Local/Microsoft/Windows/Fonts/LEMONMILK-Regular.otf
    :fontcolor=#ffffff@0.9
    :fontsize=42
    :line_spacing=6
    :alpha='if(lt(t,$startTS),0,if(lt(t,$startTS + 0.5),(t-$startTS)/0.625,if(lt(t,$startTS + 5.5),0.8,if(lt(t,$startTS + 6),(0.5-(t-($startTS + 5.5)))/0.625,0))))'
    :x=50
    :y=(h-text_h)/10*8.5"
    $filterArtist = "drawtext=
    text=${artist}
    :shadowx=4
    :shadowy=3
    :shadowcolor=black@0.35
    :borderw=2
    :bordercolor=black@0.25
    :fontfile=/Users/pixel/AppData/Local/Microsoft/Windows/Fonts/LEMONMILK-Regular.otf
    :fontcolor=#c0c0c0@0.9
    :fontsize=36
    :line_spacing=15
    :alpha='if(lt(t,$startTS),0,if(lt(t,$startTS + 0.5),(t-$startTS)/0.625,if(lt(t,$startTS + 5.5),0.8,if(lt(t,$startTS + 6),(0.5-(t-($startTS + 5.5)))/0.625,0))))'
    :x=52
    :y=(h-text_h)/10*8.5 + 50"

    return "$filterTitle, $filterArtist"
}

$videoFolder = "F:\Blender\MercyChairPiss"

Clear-Content .\config\audios.txt
    foreach ($file in Get-ChildItem $($videoFolder + "\*") -Include @("*.wav")) {
        $filePath ="file '$file'"
        # Write-Host "file '${filePath}'"
        Add-Content -Path .\config\audios.txt -Value $filePath
    }


$sousTitres = Get-Content -Path $videoFolder\soustitres.json | ConvertFrom-Json
$counter = 0
$subtitleFilter = ""
$prevAudioLength = 0

foreach ($line in Get-Content .\config\audios.txt)
{
    $line = $line.Trim("file").Trim().Trim("'")
    $counter++

    $subtitleFilter += generateTextBlurb -startTS $($prevAudioLength + 4) -title $sousTitres.Titles.$counter -artist $sousTitres.Artists.$counter
    $subtitleFilter+= ", "

    $prevAudioLength += ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $line

    $prevAudioLength = [math]::Round($prevAudioLength,2)
    echo $prevAudioLength
}

$subtitleFilter = $subtitleFilter.TrimEnd(", ")

# echo $subtitleFilter

ffplay -i "F:\Blender\MercyChairPiss\2023-05-03 23-45-38.mkv" -vf $subtitleFilter