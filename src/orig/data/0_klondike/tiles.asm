    MODULE Lev0Klondike


; #6C00
tilePixels:
        dh 00 00 00 00 00 00 00 00  ; tile #00 (bg space)
        dh 00 28 18 0C 18 18 2C 34  ; tile #01 (bg space)
        dh 56 6A 6A 62 26 30 0C 78  ; tile #02 (bg space)
        dh 68 C8 B0 40 50 88 C8 18  ; tile #03 (bg space)
        dh C0 20 18 00 40 24 1C 10  ; tile #04 (bg space)
        dh 00 00 43 34 9C 01 00 00  ; tile #05 (bg space)
        dh 60 7F D4 74 0F 04 00 10  ; tile #06 (bg space)
        dh C0 80 00 10 10 CA 32 38  ; tile #07 (bg space)
        dh 00 00 00 10 30 30 10 10  ; tile #08 (bg space)
        dh 08 0B 06 02 01 00 00 00  ; tile #09 (bg space)
        dh 1C 06 82 E0 C0 60 30 11  ; tile #0A (bg space)
        dh 11 1B 13 32 32 3A 29 08  ; tile #0B (bg space)
        dh 00 08 19 11 13 13 32 67  ; tile #0C (bg space)
        dh 18 1C 5C 5C 18 44 18 00  ; tile #0D (fg space)
        dh 80 C0 A0 D0 A0 40 80 00  ; tile #0E (fg space)
        dh 10 2A 54 6E 57 2F 5B 2F  ; tile #0F (fg space)
        dh 00 8A 45 EA B1 FB FD F7  ; tile #10 (fg space)
        dh 00 00 49 00 42 81 C8 BD  ; tile #11 (fg space)
        dh 00 00 00 00 0A 40 0A 44  ; tile #12 (fg space)
        dh 22 77 A2 55 66 44 A8 5D  ; tile #13 (fg space)
        dh 22 54 A2 74 A0 54 A8 44  ; tile #14 (fg space)
        dh A8 50 A0 50 A0 55 68 41  ; tile #15 (fg space)
        dh 28 04 AA 44 A6 14 22 54  ; tile #16 (fg space)
        dh 28 55 EA 74 2A 55 AA 55  ; tile #17 (fg space)
        dh 2A 54 AA 54 EA 44 88 54  ; tile #18 (fg space)
        dh 2A 14 0E 05 02 01 00 00  ; tile #19 (fg space)
        dh 80 40 80 40 20 14 AA 75  ; tile #1A (fg space)
        dh 03 05 0E 14 3A 55 A0 54  ; tile #1B (fg space)
        dh A8 10 A0 40 80 00 00 00  ; tile #1C (fg space)
        dh 00 51 A2 F7 A3 FF EA 11  ; tile #1D (fg space)
        dh 00 54 22 FC A0 DF AA C0  ; tile #1E (fg space)
        dh 00 15 22 55 AA F1 AA 74  ; tile #1F (fg space)
        dh FF F7 DD AA 00 AA DD 37  ; tile #20 (fg platform)
        dh FE DC F4 A8 00 AA FD 06  ; tile #21 (fg platform)
        dh F9 E4 1F F8 E7 5E AB 00  ; tile #22 (fg space)
        dh FD 47 3C DF E3 9C EA 00  ; tile #23 (fg space)
        dh 5D A2 55 AA 00 00 09 14  ; tile #24 (fg platform)
        dh 29 44 0A 50 22 54 2A 00  ; tile #25 (fg space)
        dh 57 2F 5F 6F 57 2F 5F 2F  ; tile #26 (fg space)
        dh F7 FF FB FF FF FF FF F7  ; tile #27 (fg space)
        dh E8 BD EA 74 EA 7D EA BD  ; tile #28 (fg space)
        dh 82 44 0A 02 08 04 0A 44  ; tile #29 (fg space)
        dh 00 2F 56 6F 57 2F 5B 00  ; tile #2A (fg space)
        dh 00 FF FF FF FB FF FF 00  ; tile #2B (fg space)
        dh 00 75 EB 74 E2 B5 EA 00  ; tile #2C (fg space)
        dh 00 04 0A 00 0A 40 0A 00  ; tile #2D (fg space)
        dh BF BD DF CF CD CE 5D 1A  ; tile #2E (fg wall)
        dh 14 38 28 14 18 10 10 00  ; tile #2F (fg wall)
        dh 74 76 3B 2A 10 20 30 00  ; tile #30 (fg wall)
        dh CC 58 58 51 41 43 83 07  ; tile #31 (fg wall)
        dh 06 0E 06 06 02 02 00 00  ; tile #32 (fg wall)
        dh 13 03 01 01 00 00 00 00  ; tile #33 (fg wall)
        dh 53 C1 41 80 80 00 00 00  ; tile #34 (fg wall)
        dh E0 A0 40 C0 80 00 00 00  ; tile #35 (fg wall)
        dh B0 F2 DB E9 D9 A0 D0 F0  ; tile #36 (fg wall)
        dh CC D8 D0 C0 40 40 00 00  ; tile #37 (fg wall)
        dh 10 90 90 30 60 20 00 00  ; tile #38 (fg wall)
        dh 39 19 92 95 36 65 46 36  ; tile #39 (fg wall)
        dh FB F5 EB 53 EB 55 08 1D  ; tile #3A (fg wall)
        dh E3 D3 BB 51 B8 54 BA DC  ; tile #3B (fg wall)
        dh BE 1D 3A 7B 7B 71 EB 55  ; tile #3C (fg wall)
        dh 3B 31 B3 17 83 13 9A 13  ; tile #3D (fg wall)
        dh E9 D9 9B 17 B3 71 79 31  ; tile #3E (fg wall)
        dh E3 C7 8F 1F BF 1D CF ED  ; tile #3F (fg wall)
        dh CF DD 8B 8B AB 55 E4 FC  ; tile #40 (fg wall)
        dh BE DF 8E D5 AA CC 9A D4  ; tile #41 (fg wall)
        dh 1A 14 1A 14 08 00 00 00  ; tile #42 (fg wall)
        dh 9E 1D AE D7 E2 77 23 01  ; tile #43 (fg wall)
        dh E8 74 2A 75 BE 14 88 1C  ; tile #44 (fg wall)
        dh 3B 33 2B 77 2B 55 66 55  ; tile #45 (fg wall)
        dh B8 10 80 41 A3 D7 A3 37  ; tile #46 (fg wall)
        dh AE C7 A2 F1 F2 F0 E8 D1  ; tile #47 (fg wall)
        dh 3E 5C 3A 34 AA 34 2A 50  ; tile #48 (fg wall)
        dh 98 50 A0 40 00 00 00 00  ; tile #49 (fg wall)
        dh 8A 15 3A 15 02 00 00 00  ; tile #4A (fg wall)
        dh A2 C5 AE 45 0A 05 00 00  ; tile #4B (fg wall)
        dh AE 05 AE 4D 2A 55 AA 00  ; tile #4C (fg wall)
        dh A2 55 AE 55 8A 00 00 00  ; tile #4D (fg wall)
        dh BD BE 9D CE 4D CE 5D 9A  ; tile #4E (fg wall)
        dh BE 9C 54 C9 82 85 0A 1C  ; tile #4F (fg wall)
        dh 31 B3 9B 9A 9D 1A 1C 8A  ; tile #50 (fg wall)
        dh 39 19 93 97 37 66 47 36  ; tile #51 (fg wall)
        dh 94 B8 28 34 2C 75 69 B3  ; tile #52 (fg wall)
        dh 59 55 CB E3 AB E1 B1 D1  ; tile #53 (fg wall)
        dh CC C8 A0 E9 A3 D2 AA DE  ; tile #54 (fg wall)
        dh 13 93 91 B1 64 64 4C C8  ; tile #55 (fg wall)
        dh A3 27 67 47 27 A7 B7 93  ; tile #56 (fg wall)
        dh E4 D6 EB 53 AB D2 A0 D3  ; tile #57 (fg wall)
        dh A4 68 58 51 41 C3 83 A7  ; tile #58 (fg wall)
        dh 88 88 C0 C1 41 41 23 33  ; tile #59 (fg wall)
        dh D3 D1 D9 98 B4 7A 75 7A  ; tile #5A (fg wall)
        dh A3 42 8E CC 94 3C 36 7A  ; tile #5B (fg wall)
        dh 26 6E CE 8E 8E 1F 3B 31  ; tile #5C (fg wall)
        dh 13 03 61 71 50 28 18 34  ; tile #5D (fg wall)
        dh BE BD 9E CF E6 A5 C7 CD  ; tile #5E (fg wall)
        dh BE 9C D4 58 88 08 0C 24  ; tile #5F (fg wall)
        dh 31 33 9B 9F 9E 9F 9E 8F  ; tile #60 (fg wall)
        dh 39 19 93 97 97 87 C7 47  ; tile #61 (fg wall)
        dh 4A 8C 99 B9 28 70 F4 D4  ; tile #62 (fg wall)
        dh 65 E7 CF CE 9D 1E 9D DE  ; tile #63 (fg wall)
        dh 8E 1D 3E 3D 7E 7F 7E 7D  ; tile #64 (fg wall)
        dh 93 13 11 11 98 14 BA 34  ; tile #65 (fg wall)
        dh E6 AE 66 27 33 9A 9A 96  ; tile #66 (fg wall)
        dh 5D 6E 2F 26 97 D3 57 C7  ; tile #67 (fg wall)
        dh 3A BD 2A 95 4A A5 E2 A8  ; tile #68 (fg wall)
        dh 3A 14 98 39 B1 31 63 E3  ; tile #69 (fg wall)
        dh CD DF DD BA BC 7A 75 7B  ; tile #6A (fg wall)
        dh 86 26 2E 5C 5C 34 3A 76  ; tile #6B (fg wall)
        dh EC DA 5E 5A D6 9D 3A 31  ; tile #6C (fg wall)
        dh C3 E3 61 51 70 38 18 2C  ; tile #6D (fg wall)
        dh 7B 7D 7A 34 28 14 18 10  ; tile #6E (fg wall)
        dh 76 FA 74 28 18 10 00 00  ; tile #6F (fg wall)
        dh 31 62 73 5E 2C 18 18 10  ; tile #70 (fg wall)
        dh FC BC 14 0C 08 18 10 00  ; tile #71 (fg wall)
        dh 3F 40 98 A5 A4 98 40 3F  ; tile #72 (fg left conveyor)
        dh CF 00 30 4B 48 30 00 FC  ; tile #73 (fg left conveyor)
        dh CF 00 30 4B 48 30 00 FC  ; tile #74 (fg right conveyor)
        dh FC 02 19 A5 25 19 02 FC  ; tile #75 (fg left conveyor)
        dh 3F 40 98 A5 A4 98 40 3F  ; tile #76 (fg right conveyor)
        dh FC 02 19 A5 25 19 02 FC  ; tile #77 (fg right conveyor)
        dh 00 8B 04 C0 1C 80 02 00  ; tile #78 (fg water/spikes)
        dh 00 80 12 00 08 01 00 40  ; tile #79 (fg water/spikes)
        dh 38 18 90 90 30 60 40 30  ; tile #7A (fg wall)
        dh 10 90 90 B0 60 60 40 C0  ; tile #7B (fg wall)
        dh 80 80 C0 C0 40 40 20 30  ; tile #7C (fg wall)
        dh 10 00 60 70 70 28 18 34  ; tile #7D (fg wall)
        dh 3F 3E 1F 0E 0D 0E 1D 1A  ; tile #7E (fg wall)
        dh 14 38 38 34 3C 75 69 33  ; tile #7F (fg wall)
        dh 23 27 67 47 27 27 37 13  ; tile #80 (fg wall)
        dh 13 11 19 18 34 7A 75 7B  ; tile #81 (fg wall)
        dh 82 84 84 48 C5 4F DD 9A  ; tile #82 (fg wall)
        dh 00 04 0A 02 81 8A 0E 1C  ; tile #83 (fg wall)
        dh 08 50 20 64 0E 1D 1A 8E  ; tile #84 (fg wall)
        dh 21 21 2B B7 77 67 06 17  ; tile #85 (fg wall)
        dh 00 55 FF AA FF D4 AA D4  ; tile #86 (fg space)
        dh 00 55 FF AA 55 AA 00 22  ; tile #87 (fg space)
        dh 00 05 2F 02 01 00 00 00  ; tile #88 (fg space)
        dh 0C 1C 1D 1D 0C 11 0C 00  ; tile #89 (fg space)
        dh 7C 78 7C 54 74 54 58 54  ; tile #8A (fg wall)
        dh 74 54 7C 58 6C 68 2C EC  ; tile #8B (fg wall)
        dh 01 57 FF AF 5D BB 76 FE  ; tile #8C (fg wall)
        dh AC A4 D4 1C DC 54 54 5C  ; tile #8D (fg wall)
        dh 80 55 AF F5 EA FD 56 33  ; tile #8E (fg wall)
        dh 18 38 5A 42 42 5A 38 18  ; tile #8F (fg space)
        dh 18 38 5A 42 42 5A 38 18  ; tile #90 (fg space)
        dh 18 3C 5A 81 99 FB 7A 18  ; tile #91 (fg space)
        dh FF FF FF BF 4D 83 00 58  ; tile #92 (fg slow)
        dh 7F BF 5B A4 40 80 00 08  ; tile #93 (fg slow)
        dh FB FF 7F 2F 1F 06 10 84  ; tile #94 (fg slow)
        dh FD EB F5 AA D0 60 01 12  ; tile #95 (fg slow)
        dh 7F FF FF FF 4F 02 10 28  ; tile #96 (fg slow)
        dh FE FF FD EA 54 A0 00 04  ; tile #97 (fg slow)
        dh FF FF FF BF 4D 83 40 D8  ; tile #98 (fg wall)
        dh 7F BF 5B A4 40 80 00 08  ; tile #99 (fg wall)
        dh FB FF 7F 2F 1F 06 10 8C  ; tile #9A (fg wall)
        dh FD EB F5 AA D0 60 01 33  ; tile #9B (fg wall)
        dh 7F FF FF FF 4F 02 10 3C  ; tile #9C (fg wall)
        dh 3F 3E 1F 0E 0D 0E 1D 1A  ; tile #9D (fg wall)
        dh 74 78 F4 E8 F4 E9 D1 6B  ; tile #9E (fg wall)
        dh 73 57 67 67 47 27 27 03  ; tile #9F (fg wall)
        dh 13 11 29 38 74 7A 74 6A  ; tile #A0 (fg wall)
        dh FE FF FD EA 54 A0 00 04  ; tile #A1 (fg wall)
        dh 38 1C 98 90 30 60 40 30  ; tile #A2 (fg wall)
        dh 10 98 B4 B8 74 78 74 E8  ; tile #A3 (fg wall)
        dh F8 A8 F0 D0 60 60 20 30  ; tile #A4 (fg wall)
        dh 10 20 50 F0 E8 74 7C 34  ; tile #A5 (fg wall)
        dh 00 10 38 C6 FE 74 AA 54  ; tile #A6 (fg platform)
        dh 70 6A 70 7A 70 3A 70 7A  ; tile #A7 (bg ladder)
        dh 70 7A 30 7A 30 7A 70 7A  ; tile #A8 (bg ladder)
        dh 00 BF FF FB 55 00 51 00  ; tile #A9 (bg ladder top)
        dh 00 F5 DF F7 55 00 55 00  ; tile #AA (bg ladder top)
        dh 01 07 19 27 2F 5D 59 FF  ; tile #AB (bg ladder top)
        dh 80 A0 98 A4 B4 BA 9A FF  ; tile #AC (bg ladder top)
        dh FF 01 5D 2D 25 19 05 01  ; tile #AD (bg ladder)
        dh FF 80 9A B4 A4 98 A0 80  ; tile #AE (bg ladder)
        dh 00 7F 3F 3F 15 00 05 00  ; tile #AF (bg ladder top)
        dh 00 40 70 7A 70 7A 70 7A  ; tile #B0 (bg ladder)
        dh FF FF FD E5 E5 FD C1 FF  ; tile #B1 (bg ladder top)
        dh 36 72 61 D1 E1 C2 66 24  ; tile #B2 (bg space)
        dh 62 C7 C5 88 8A CE 46 A2  ; tile #B3 (bg space)
        dh 15 1C 18 B0 30 22 44 C4  ; tile #B4 (bg space)
        dh C7 C6 8E 8C 04 44 22 22  ; tile #B5 (bg space)
        dh 04 10 11 21 42 46 24 10  ; tile #B6 (bg space)
        dh 08 10 10 40 48 88 8C 04  ; tile #B7 (bg space)
        dh 00 00 00 00 00 00 00 00  ; tile #B8 (bg space)
        dh 00 C2 92 04 21 21 01 02  ; tile #B9 (bg space)
        dh 00 40 40 80 40 80 12 48  ; tile #BA (bg space)
        dh 00 00 00 03 1D B7 7F EF  ; tile #BB (bg space)
        dh 00 00 00 40 B0 0A D5 6B  ; tile #BC (bg space)
        dh 6F 5D 6F 5D 6F 5D 6F 5D  ; tile #BD (bg wall)
        dh A2 52 A2 52 A2 52 A2 52  ; tile #BE (bg wall)
        dh 70 70 DB EB B7 28 58 78  ; tile #BF (bg ladder)
        dh 0E 0E FD F9 7F 10 1E 0E  ; tile #C0 (bg ladder)
        dh 38 10 69 FB FB 6E 60 10  ; tile #C1 (bg ladder)
        dh 0C CD F9 F6 FB A8 87 86  ; tile #C2 (bg ladder)
        dh 30 30 E0 CF 27 45 64 70  ; tile #C3 (bg ladder)
        dh 07 07 0E 0E F8 F3 9E 80  ; tile #C4 (bg ladder)
        dh FF EB F7 28 58 78 78 78  ; tile #C5 (bg ladder top)
        dh FD F9 7F 10 1E 0E 0E 0E  ; tile #C6 (bg ladder top)
        dh 7E 6E 3A 1E 1B 2B 2D 4D  ; tile #C7 (bg ladder)
        dh 0D 0A 1E 3E 3A 3C 68 54  ; tile #C8 (bg ladder)
        dh E4 C2 C2 C0 40 40 60 20  ; tile #C9 (bg ladder)
        dh 75 79 6A 78 70 3C 2C 5A  ; tile #CA (bg ladder)
        dh 9E 8E 8E 45 46 2E 0E 0A  ; tile #CB (bg ladder)
        dh 1C 3C 5A 19 39 31 32 34  ; tile #CC (bg ladder)
        dh 64 64 62 20 20 30 10 08  ; tile #CD (bg ladder)
        dh FC C8 A4 50 00 65 FF 1D  ; tile #CE (bg platform)
        dh 00 00 00 00 00 80 80 40  ; tile #CF (bg space)
        dh 60 10 0D 03 01 00 00 00  ; tile #D0 (bg space)
        dh 00 00 00 AB 7C 28 00 00  ; tile #D1 (bg space)
        dh 38 74 EA F4 BA 34 DA E6  ; tile #D2 (bg space)
        dh 6E B4 5A EC CE 04 60 F4  ; tile #D3 (bg space)
        dh EA D4 EA F4 FA 74 EA 74  ; tile #D4 (bg space)
        dh FC 92 A8 5C 08 1C FE 9C  ; tile #D5 (bg wall)
        dh 1C 18 08 1C 7E 9E BD 10  ; tile #D6 (bg space)
        dh 00 00 40 C9 BE 14 00 00  ; tile #D7 (bg space)
        dh 06 1C B0 C0 80 00 00 00  ; tile #D8 (bg space)
        dh 00 00 00 01 00 01 01 02  ; tile #D9 (bg space)
        dh FE D4 AA 54 00 38 7F 39  ; tile #DA (bg wall)
        dh 55 BF 56 3F 55 20 15 00  ; tile #DB (bg platform)
        dh 6D 6C FB ED 7D AA 6D 48  ; tile #DC (bg platform)
        dh 55 FF EF BD 15 AA 55 00  ; tile #DD (bg platform)
        dh FE 51 AC D3 A8 25 B2 D4  ; tile #DE (bg space)
        dh FF 24 48 10 E0 20 40 80  ; tile #DF (bg space)
        dh 99 AA CC 94 20 C0 80 80  ; tile #E0 (bg space)
        dh FF 24 12 08 07 04 02 01  ; tile #E1 (bg space)
        dh 7F 8B 35 CB 15 A4 4D 2A  ; tile #E2 (bg space)
        dh 99 55 33 29 04 03 01 01  ; tile #E3 (bg space)
        dh 00 5F 20 4C 01 20 00 00  ; tile #E4 (fg water/spikes)
        dh 10 10 10 10 10 10 10 10  ; tile #E5 (bg space)
        dh 10 10 18 34 24 7A FD 00  ; tile #E6 (bg space)
        dh 5A 6E 7E 76 66 5A C3 FD  ; tile #E7 (bg space)
        dh 34 38 3C 1C 24 38 3C 1C  ; tile #E8 (bg ladder)
        dh 24 18 2C 26 4A 4C 94 3C  ; tile #E9 (bg ladder)
        dh 34 7A 3D 1D 24 78 BC 1C  ; tile #EA (bg ladder)
        dh 35 BB DB 8D 0D 9C 19 00  ; tile #EB (bg ladder top)
        dh 01 06 0C 11 26 65 4B 27  ; tile #EC (bg space)
        dh 5F BF 3F 5F BF FE FF F7  ; tile #ED (bg space)
        dh AA 55 FE 5D FA B1 F8 F4  ; tile #EE (bg space)
        dh 00 40 A8 54 AA 54 2A 15  ; tile #EF (bg space)
        dh 6B 3F 57 2B 55 2E 17 1B  ; tile #F0 (bg space)
        dh FE FF FB FF 7F BD DE FD  ; tile #F1 (bg space)
        dh BA 7D FA F5 EA 55 AA 50  ; tile #F2 (bg space)
        dh 8A 15 8A 05 84 09 15 09  ; tile #F3 (bg space)
        dh 04 10 11 21 42 46 24 10  ; tile #F4 (bg space)
        dh 0F 0B 75 E6 F1 A0 48 34  ; tile #F5 (bg space)
        dh FE FF FE FF BE 6F 1E 05  ; tile #F6 (bg space)
        dh A0 40 80 00 80 40 A0 40  ; tile #F7 (bg space)
        dh 00 01 03 07 82 04 A4 43  ; tile #F8 (bg space)
        dh A8 D0 A4 50 A0 00 02 00  ; tile #F9 (bg space)
        dh 00 07 1F 3F 7E 7C FC 7E  ; tile #FA (bg space)
        dh 00 80 C0 50 E8 54 88 00  ; tile #FB (bg space)
        dh 3F 5E 2C 50 28 10 00 00  ; tile #FC (bg space)
        dh 04 82 00 10 24 00 10 00  ; tile #FD (bg space)
        dh 00 00 5D F7 DB 00 00 00  ; tile #FE (bg space)
        dh 00 00 00 00 00 00 00 00  ; tile #FF (bg space)

; #7400
tileAttrs:
        dh 47 04 44 04 44 02 02 02 02 02 02 02 02 47 04 16  ; tiles #0x
        dh 56 16 14 46 44 46 44 46 44 46 46 06 06 46 44 04  ; tiles #1x
        dh 46 46 46 46 06 06 16 56 16 14 45 47 45 05 44 44  ; tiles #2x
        dh 44 44 44 44 44 44 44 44 44 44 46 46 46 46 46 46  ; tiles #3x
        dh 46 46 46 46 46 46 46 46 46 46 46 46 46 46 04 04  ; tiles #4x
        dh 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04  ; tiles #5x
        dh 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04  ; tiles #6x
        dh 04 04 45 45 45 45 45 45 43 43 44 44 44 44 44 44  ; tiles #7x
        dh 44 44 44 44 44 44 07 07 07 47 46 46 46 46 06 47  ; tiles #8x
        dh 07 47 46 46 46 46 46 46 44 44 44 44 44 44 44 44  ; tiles #9x
        dh 44 44 44 44 44 44 47 07 07 07 07 47 47 47 47 07  ; tiles #Ax
        dh 07 47 42 42 42 42 42 42 47 04 04 46 46 47 47 46  ; tiles #Bx
        dh 46 46 46 46 46 46 46 06 06 06 04 04 04 04 46 06  ; tiles #Cx
        dh 06 06 46 46 46 46 46 06 06 06 46 46 46 46 07 07  ; tiles #Dx
        dh 07 07 07 07 43 05 06 46 46 46 46 46 47 47 07 07  ; tiles #Ex
        dh 47 07 07 07 07 47 07 07 07 07 47 07 07 07 46 47  ; tiles #Fx

; #7500
tileTypes:
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 80 80 80  ; tiles #0x
        dh 80 80 80 80 80 80 80 80 80 80 80 80 80 80 80 80  ; tiles #1x
        dh 83 83 80 80 83 80 80 80 80 80 80 80 80 80 84 84  ; tiles #2x
        dh 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84  ; tiles #3x
        dh 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84  ; tiles #4x
        dh 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84  ; tiles #5x
        dh 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84 84  ; tiles #6x
        dh 84 84 85 85 86 85 86 86 89 89 84 84 84 84 84 84  ; tiles #7x
        dh 84 84 84 84 84 84 80 80 80 80 84 84 84 84 84 80  ; tiles #8x
        dh 80 80 88 88 88 88 88 88 84 84 84 84 84 84 84 84  ; tiles #9x
        dh 84 84 84 84 84 84 83 01 01 02 02 02 02 01 01 02  ; tiles #Ax
        dh 01 02 00 00 00 00 00 00 00 00 00 00 00 04 04 01  ; tiles #Bx
        dh 01 01 01 01 01 02 02 01 01 01 01 01 01 01 03 00  ; tiles #Cx
        dh 00 00 00 00 00 04 00 00 00 00 04 03 03 03 00 00  ; tiles #Dx
        dh 00 00 00 00 89 00 00 00 01 01 01 02 00 00 00 00  ; tiles #Ex
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; tiles #Fx

; #7600
tileBlocks:
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #00
        dh 4E 4F 50 51 52 53 54 55 56 57 58 59 5A 5B 5C 5D  ; block #01
        dh 9D 4F 50 51 9E 53 54 55 9F 57 58 59 A0 5B 5C 5D  ; block #02
        dh 5E 5F 60 61 62 63 64 65 66 67 68 69 6A 6B 6C 6D  ; block #03
        dh 5E 5F 60 A2 62 63 64 A3 66 67 68 A4 6A 6B 6C A5  ; block #04
        dh 2E 4F 50 51 2F 53 54 55 00 30 31 59 00 00 32 33  ; block #05
        dh 4E 4F 50 39 52 53 54 38 56 36 37 00 34 35 00 00  ; block #06
        dh 6E 6F 70 71 00 00 00 00 00 00 00 00 00 00 00 00  ; block #07
        dh 98 99 9A 9B 52 53 54 55 56 57 58 59 5A 5B 5C 5D  ; block #08
        dh 9C 99 9A 9B 9E 53 54 55 9F 57 58 59 A0 5B 5C 5D  ; block #09
        dh 98 99 9A A1 52 53 54 A3 56 57 58 A4 5A 5B 5C A5  ; block #0A
        dh 9C 99 9A A1 9E 53 54 A3 9F 57 58 A4 A0 5B 5C A5  ; block #0B
        dh 00 00 9C 9B 00 00 9E 55 9C 98 58 59 9D 5B 5C 5D  ; block #0C
        dh 98 99 9A 9B 62 63 64 65 66 67 68 69 6A 6B 6C 6D  ; block #0D
        dh 92 93 94 95 52 53 54 55 56 57 58 59 5A 5B 5C 5D  ; block #0E
        dh 92 93 94 95 62 63 64 65 66 67 68 69 6A 6B 6C 6D  ; block #0F
        dh 96 93 94 95 9E 53 54 55 9F 57 58 59 A0 5B 5C 5D  ; block #10
        dh 92 93 94 97 52 53 54 A3 56 57 58 A4 5A 5B 5C A5  ; block #11
        dh 96 93 94 97 9E 53 54 A3 9F 57 58 A4 A0 5B 5C A5  ; block #12
        dh 98 A1 00 00 62 A5 00 00 66 67 9A A1 6A 6B 6C A5  ; block #13
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #14
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #15
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #16
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #17
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #18
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #19
        dh 00 00 00 00 00 00 00 00 00 00 00 00 87 86 87 86  ; block #1A
        dh 00 00 00 00 00 89 8A 00 00 00 8B 00 87 8C 8D 8E  ; block #1B
        dh 00 00 00 00 00 00 00 00 00 00 00 00 BB BC BB BC  ; block #1C
        dh 00 00 00 00 EC ED EE EF F0 F1 F2 F3 F5 F6 F7 F8  ; block #1D
        dh 00 00 00 00 00 00 00 00 F4 FA FB 00 F9 FC FD 00  ; block #1E
        dh 00 00 00 00 00 00 00 00 00 00 FA FB 00 00 FC FD  ; block #1F
        dh 6E 6F 70 71 00 00 00 00 00 00 00 00 87 86 87 86  ; block #20
        dh 6E 6F 70 71 00 00 00 00 00 00 00 00 00 00 00 00  ; block #21
        dh 00 00 00 00 00 00 00 00 00 00 00 00 72 73 73 73  ; block #22
        dh 00 00 00 00 00 00 00 00 00 00 00 00 73 73 73 73  ; block #23
        dh 00 00 00 00 00 00 00 00 00 00 00 00 73 73 73 75  ; block #24
        dh 78 E4 78 E4 79 79 79 79 79 79 79 79 79 79 79 79  ; block #25
        dh 4E 4F 50 7A 52 53 54 7B 56 57 58 7C 5A 5B 5C 7D  ; block #26
        dh 7E 4F 50 51 7F 53 54 55 80 57 58 59 81 5B 5C 5D  ; block #27
        dh 82 83 84 85 52 53 54 55 56 57 58 59 5A 5B 5C 5D  ; block #28
        dh DB DD DC DD 00 00 00 00 00 00 00 00 00 00 00 00  ; block #29
        dh DD DD DC DD 00 00 00 00 00 00 00 00 00 00 00 00  ; block #2A
        dh DD EB DC DD 00 E8 00 00 00 E9 00 00 00 E8 00 00  ; block #2B
        dh 6E 6F 70 71 00 E8 00 00 00 E9 00 00 00 E8 00 00  ; block #2C
        dh 00 00 00 00 00 00 00 00 20 21 20 21 22 23 22 23  ; block #2D
        dh 6E 6F 70 71 00 00 E5 00 00 00 E6 00 00 00 E7 00  ; block #2E
        dh 00 8F 00 00 00 8F 00 00 00 8F 00 00 00 91 00 00  ; block #2F
        dh 6E 90 70 71 00 8F 00 00 00 8F 00 00 00 91 00 00  ; block #30
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #31
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #32
        dh 00 00 00 15 00 00 00 17 00 00 00 13 87 86 87 86  ; block #33
        dh 00 00 00 D2 D2 00 D9 D3 D3 D7 D8 D4 D4 00 00 D4  ; block #34
        dh 00 00 00 00 CF 00 D2 00 D0 D1 D3 CF 00 00 D4 D0  ; block #35
        dh 00 00 00 00 00 00 00 00 00 D2 00 00 D1 D3 CF 00  ; block #36
        dh 00 00 00 00 00 00 00 00 00 00 00 00 D2 00 00 00  ; block #37
        dh D5 00 D4 00 D6 CE D5 00 00 00 D6 CE 00 00 00 00  ; block #38
        dh 00 D4 D0 D1 00 D4 00 00 CE D5 00 00 00 D6 CE CE  ; block #39
        dh D3 CF 00 D2 D4 D0 D1 D3 D4 00 00 D4 CE D5 00 D4  ; block #3A
        dh 00 00 D2 00 FE FE D3 FE 00 00 D4 00 00 00 D4 00  ; block #3B
        dh 00 D2 00 00 FE D3 FE FE 00 D4 00 00 00 D4 00 00  ; block #3C
        dh D2 00 D9 D3 D3 D7 D8 D4 D4 00 00 D4 D4 00 DA CE  ; block #3D
        dh D7 D8 D4 00 00 00 D4 00 00 00 DA CE CE CE D6 00  ; block #3E
        dh 00 D4 00 DA 00 DA CE D6 CE D6 00 00 00 00 00 00  ; block #3F
        dh 00 D6 CE CE 00 00 00 00 00 00 00 00 00 00 00 00  ; block #40
        dh CE CE CE CE 00 00 00 00 00 00 00 00 00 00 00 00  ; block #41
        dh CE CE D6 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #42
        dh 20 21 20 21 22 23 22 23 0F 10 11 12 2A 2B 2C 2D  ; block #43
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 D2  ; block #44
        dh 00 00 00 00 00 00 00 00 00 00 D2 00 00 00 D3 D7  ; block #45
        dh 00 00 00 00 00 D2 00 D9 00 D3 D7 D8 D8 D4 00 00  ; block #46
        dh D2 00 00 00 D3 CF 00 D2 D4 D0 D1 D3 D4 00 00 D4  ; block #47
        dh 3A 3B 3C 3D 42 43 44 45 00 00 4A 4B 00 00 00 00  ; block #48
        dh 3E 3F 40 41 46 47 48 49 4C 4D 00 00 00 00 00 00  ; block #49
        dh 1D 1E 1F 13 00 19 1A 15 00 00 19 17 00 00 00 13  ; block #4A
        dh 14 1D 1E 1F 16 1B 1C 00 18 1C 00 00 14 00 00 00  ; block #4B
        dh 00 00 00 15 00 00 00 17 00 00 00 13 00 00 00 17  ; block #4C
        dh 16 00 00 00 18 00 00 00 14 00 00 00 18 00 00 00  ; block #4D
        dh 20 21 20 21 22 23 22 23 00 00 00 00 00 00 00 00  ; block #4E
        dh 24 21 20 21 25 23 22 23 00 00 00 00 00 00 00 00  ; block #4F
        dh 26 27 28 29 2A 2B 2C 2D 26 27 28 29 2A 2B 2C 2D  ; block #50
        dh C5 C6 24 21 C1 C2 25 23 BF C0 00 00 C3 C4 00 00  ; block #51
        dh 00 00 00 00 00 AB AF AA 00 B0 00 00 00 A8 00 00  ; block #52
        dh 00 00 00 00 A9 AC 00 00 00 B0 00 00 00 A8 00 00  ; block #53
        dh 00 A8 00 00 00 AD AF AA 00 00 00 00 00 00 00 00  ; block #54
        dh 00 A7 00 00 A9 AE 00 00 00 00 00 00 00 00 00 00  ; block #55
        dh 00 E8 00 00 00 E9 00 00 00 E8 00 00 00 EA 00 00  ; block #56
        dh 16 00 00 00 18 00 00 00 14 00 00 00 87 86 87 86  ; block #57
        dh 00 D2 00 00 00 D3 00 00 00 D4 00 00 A6 D4 A6 00  ; block #58
        dh BF C0 00 00 C1 C2 00 00 BF C0 00 00 C3 C4 00 00  ; block #59
        dh 6E CA C7 71 00 CB C8 00 00 CC C9 00 00 CD 00 00  ; block #5A
        dh C7 6F CA C7 C8 00 CB C8 C9 00 CC C9 00 00 CD 00  ; block #5B
        dh 9C 99 9A 9B 2F 53 54 55 00 30 31 59 00 00 32 33  ; block #5C
        dh 98 99 9A A1 52 53 54 38 56 36 37 00 34 35 00 00  ; block #5D
        dh 00 A7 00 00 00 A8 00 00 00 A7 00 00 00 A8 00 00  ; block #5E
        dh 00 00 00 00 A9 AA A9 AA 00 00 00 00 00 00 00 00  ; block #5F
        dh 6E B0 70 71 00 A8 00 00 00 A7 00 00 00 A8 00 00  ; block #60
        dh 6E 6F 70 71 A9 AA A9 AA 00 00 00 00 00 00 00 00  ; block #61
        dh 00 A7 00 00 00 A8 00 00 00 A7 00 00 00 A8 00 00  ; block #62
        dh 00 00 00 00 AF AA A9 AA 00 00 00 00 00 00 00 00  ; block #63
        dh DE DF 00 00 E0 00 00 00 00 00 00 00 00 00 00 00  ; block #64
        dh E1 E2 DE DF 00 E3 E0 00 00 00 00 00 00 00 00 00  ; block #65
        dh 00 00 E1 E2 00 00 00 E3 00 00 00 00 00 00 00 00  ; block #66
        dh 00 00 00 00 A9 AC 00 00 00 01 00 00 00 02 00 00  ; block #67
        dh 79 79 79 79 79 79 79 79 79 79 79 79 79 79 79 79  ; block #68
        dh 0F 10 11 12 2A 2B 2C 2D 26 27 28 29 2A 2B 2C 2D  ; block #69
        dh C5 C6 DB DD C1 C2 00 00 BF C0 00 00 C3 C4 00 00  ; block #6A
        dh 00 A7 00 00 A9 B1 AF AA 00 B0 00 00 00 A8 00 00  ; block #6B
        dh C5 C6 00 00 C1 C2 00 00 BF C0 00 00 C3 C4 00 00  ; block #6C
        dh 00 00 C5 C6 00 00 C1 C2 00 00 BF C0 00 00 C3 C4  ; block #6D
        dh 00 00 BF C0 00 00 C1 C2 00 00 BF C0 00 00 C3 C4  ; block #6E
        dh 00 AB AF AA 00 01 00 00 00 02 00 00 00 03 00 00  ; block #6F
        dh 00 00 00 00 00 00 00 00 00 00 00 00 88 86 87 86  ; block #70
        dh 6E 90 70 71 00 8F 00 00 00 8F 00 00 00 8F 00 00  ; block #71
        dh 00 8F 00 00 00 8F 00 00 00 8F 00 00 00 8F 00 00  ; block #72
        dh 00 00 00 00 00 00 00 00 00 00 00 00 74 74 74 74  ; block #73
        dh 00 04 00 00 00 01 00 00 00 02 00 00 00 03 00 00  ; block #74
        dh 00 00 00 00 00 00 00 00 00 00 00 00 76 74 74 74  ; block #75
        dh 00 00 00 00 00 00 00 00 00 00 00 00 74 74 74 77  ; block #76
        dh 72 73 73 73 00 00 00 00 00 00 00 00 00 00 00 00  ; block #77
        dh 73 73 73 73 00 00 00 00 00 00 00 00 00 00 00 00  ; block #78
        dh 73 73 73 75 00 00 00 00 00 00 00 00 00 00 00 00  ; block #79
        dh 76 74 74 74 00 00 00 00 00 00 00 00 00 00 00 00  ; block #7A
        dh 74 74 74 74 00 00 00 00 00 00 00 00 00 00 00 00  ; block #7B
        dh 74 74 74 77 00 00 00 00 00 00 00 00 00 00 00 00  ; block #7C
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #7D
        dh 00 00 00 00 00 00 00 00 C5 C6 24 21 C1 C2 25 23  ; block #7E
        dh 00 00 00 00 00 00 00 00 24 21 20 21 25 23 22 23  ; block #7F
        dh 20 21 20 21 22 23 22 23 1D 1E 1F 13 00 19 1A 15  ; block #80
        dh 20 21 20 21 22 23 22 23 14 1D 1E 1F 16 1B 1C 00  ; block #81
        dh 00 E8 00 00 00 E9 00 00 00 00 00 00 00 00 00 00  ; block #82
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #83
        dh 05 06 07 08 00 00 09 0A 00 00 00 0B 00 00 00 0C  ; block #84
        dh 00 00 00 00 00 00 00 00 00 00 00 00 B9 BA B9 BA  ; block #85
        dh 00 00 00 00 00 00 00 00 00 00 00 00 B9 BA B9 BA  ; block #86
        dh 00 00 00 00 00 00 00 00 00 00 00 00 B9 1B 0E BA  ; block #87
        dh 00 04 00 00 00 01 00 00 00 02 00 00 B9 03 B9 BA  ; block #88
        dh 00 04 00 00 00 01 00 00 00 02 00 00 B9 03 B9 BA  ; block #89
        dh 00 00 00 00 98 99 9A 9B 56 57 58 59 5A 5B 5C 5D  ; block #8A
        dh 00 00 00 00 00 00 00 00 98 99 9A 9B 5A 5B 5C 5D  ; block #8B
        dh 00 00 00 00 00 00 00 00 00 00 00 00 98 99 9A 9B  ; block #8C
        dh 00 00 00 00 00 00 00 00 00 00 00 00 9C 99 9A 9B  ; block #8D
        dh 00 00 00 00 00 00 00 00 9C 99 9A 9B 5A 5B 5C 5D  ; block #8E
        dh 00 00 00 00 9C 99 9A 9B 9F 57 58 59 A0 5B 5C 5D  ; block #8F
        dh 00 00 00 00 98 99 9A A1 56 57 58 A4 5A 5B 5C A5  ; block #90
        dh 00 00 00 00 00 00 00 00 98 99 9A A1 5A 5B 5C A5  ; block #91
        dh 00 00 00 00 00 00 00 00 00 00 00 00 98 99 9A A1  ; block #92
        dh 7E 4F 50 7A 7F 53 54 7B 80 57 58 7C 81 5B 5C 7D  ; block #93
        dh 9C 99 9A A1 7F 53 54 7B 80 57 58 7C 81 5B 5C 7D  ; block #94
        dh 00 00 00 00 78 E4 78 E4 79 79 79 79 79 79 79 79  ; block #95
        dh 98 99 9A A1 52 53 54 7B 56 57 58 7C 5A 5B 5C 7D  ; block #96
        dh 9C 99 9A 9B 7F 53 54 55 80 57 58 59 81 5B 5C 5D  ; block #97
        dh 00 00 00 00 00 00 00 00 00 00 00 00 BB BC BB BC  ; block #98
        dh 00 00 00 00 00 00 8A 0D 00 00 8B 00 87 8C 8D 8E  ; block #99
        dh 7E 4F 50 A2 7F 53 54 A3 80 57 58 A4 81 5B 5C A5  ; block #9A
        dh 9D 4F 50 7A 9E 53 54 7B 9F 57 58 7C A0 5B 5C 7D  ; block #9B
        dh 9C 99 9A A1 7F 53 54 A3 80 57 58 A4 81 5B 5C A5  ; block #9C
        dh 9C 99 9A A1 9E 53 54 7B 9F 57 58 7C A0 5B 5C 7D  ; block #9D
        dh 00 00 00 00 00 00 00 00 98 99 9A 9B 5A 5B 5C 5D  ; block #9E
        dh 00 00 00 00 00 00 00 00 98 99 9A A1 5A 5B 5C A5  ; block #9F
        dh 00 00 19 17 00 00 00 13 00 00 00 13 00 00 00 17  ; block #A0
        dh 18 1C 00 00 14 00 00 00 14 00 00 00 18 00 00 00  ; block #A1
        dh 72 73 73 75 00 00 00 00 00 00 00 00 00 00 00 00  ; block #A2
        dh 76 74 74 77 00 00 00 00 00 00 00 00 00 00 00 00  ; block #A3
        dh 00 00 00 00 00 00 00 00 00 00 00 00 72 73 73 75  ; block #A4
        dh 00 00 00 00 00 00 00 00 00 00 00 00 76 74 74 77  ; block #A5
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #A6
        dh 6E 6F 70 71 00 00 00 00 00 00 00 00 00 00 00 00  ; block #A7
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #A8
        dh 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ; block #A9
        dh 2E 4F 50 51 2F 53 54 55 00 30 31 59 00 00 32 33  ; block #AA
        dh DB DD DC DD 00 00 00 00 00 00 00 00 00 00 00 00  ; block #AB
        dh 9D 4F 50 A2 9E 53 54 A3 9F 57 58 A4 A0 5B 5C A5  ; block #AC
        dh DD DD DC DD 00 00 00 00 00 00 00 00 00 00 00 00  ; block #AD
.end:
        block 1312, 0           ; padding


    ENDMODULE
