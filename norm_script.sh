#!/usr/bin/env bash
awk 'BEGIN {buf = "lol"}
{
    if (buf != "lol" && $1 == "Norme:")
    {
        if (buf ~ /Norme:*/)
            print "\x1B[38;5;29m" buf "\x1B[38;5;0m"
        else
            print "\x1B[38;5;254m" buf "\x1B[38;5;0m"
    }
    else if (buf != "lol")
    {
        if (buf ~ /Norme:*/)
            print "\x1B[38;5;202m" buf "\x1B[38;5;0m"
        else
            print "\x1B[38;5;254m" buf "\x1B[38;5;0m"
    }
    buf = $0
}
END {
    if (buf != "lol")
    {
        if (buf ~ /Norme:*/)
        {
            print "\x1B[38;5;29m" buf "\x1B[38;5;0m"
        }
        else
        {
            print "\x1B[38;5;254m" buf "\x1B[38;5;0m"
        }
    }
}
'
