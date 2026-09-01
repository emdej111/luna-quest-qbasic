' ==========================================================
'  LUNINA POTRAGA  v2  -  QBASIC / QB64
'  Luna skakuce po galaksiji,
'  trazi 5 predmeta i BJEZI od Omega-stvorenja (crveni Q).
'  - zvuk kad se zaleti u zid
'  - zvuk kad je stvorenje dotakne (gubi zivot)
'  - zvuk kad nade predmet
'  Strelice = skok   ESC = izlaz
' ==========================================================

DECLARE SUB Uvod ()
DECLARE SUB InitMapa ()
DECLARE SUB CrtajMapu ()
DECLARE SUB CrtajCel (r%, c%)
DECLARE SUB CrtajEntitete ()
DECLARE SUB Hud ()
DECLARE SUB Poklon (n%)
DECLARE SUB PomakniNeprijatelje ()
DECLARE SUB Sudar ()
DECLARE SUB Pobjeda ()
DECLARE SUB GameOver ()

DIM SHARED px%, py%, skupljeno%, ukupno%
DIM SHARED zdravlje%, gotovo%
DIM SHARED ne%, ex%(1 TO 5), ey%(1 TO 5)
DIM SHARED mapa$(1 TO 15)
DIM SHARED zid$

RANDOMIZE TIMER
zid$ = CHR$(178)
ukupno% = 5
skupljeno% = 0
zdravlje% = 3
gotovo% = 0

CALL Uvod
CALL InitMapa

' pocetni polozaji
px% = 2: py% = 2
ne% = 3
ex%(1) = 38: ey%(1) = 2
ex%(2) = 38: ey%(2) = 14
ex%(3) = 2: ey%(3) = 14

CLS
CALL CrtajMapu
CALL CrtajEntitete
CALL Hud

' ---------------- GLAVNA PETLJA ----------------
takt# = TIMER
DO
    tipka$ = INKEY$
    IF tipka$ = CHR$(27) THEN EXIT DO

    ' --- kretanje Lune ---
    IF LEN(tipka$) = 2 THEN
        k$ = RIGHT$(tipka$, 1)
        nx% = px%: ny% = py%
        IF k$ = CHR$(72) THEN ny% = py% - 1
        IF k$ = CHR$(80) THEN ny% = py% + 1
        IF k$ = CHR$(75) THEN nx% = px% - 1
        IF k$ = CHR$(77) THEN nx% = px% + 1

        polje$ = MID$(mapa$(ny%), nx%, 1)
        IF polje$ = zid$ THEN
            SOUND 120, 1.5                       ' UDARAC u zid
        ELSE
            LOCATE py%, px%: CALL CrtajCel(py%, px%)
            px% = nx%: py% = ny%

            IF polje$ >= "1" AND polje$ <= "5" THEN
                n% = VAL(polje$)
                MID$(mapa$(py%), px%, 1) = " "
                skupljeno% = skupljeno% + 1
                SOUND 900, 1: SOUND 1300, 1       ' PREDMET
                CALL Poklon(n%)
                CALL CrtajMapu
                CALL CrtajEntitete
                CALL Hud
            END IF

            LOCATE py%, px%: COLOR 6: PRINT CHR$(2);

            FOR i% = 1 TO ne%
                IF ex%(i%) = px% AND ey%(i%) = py% THEN CALL Sudar
            NEXT

            IF skupljeno% = ukupno% THEN
                CALL Pobjeda
                EXIT DO
            END IF
        END IF
    END IF

    ' --- neprijatelji se micu na prvi pomak Lune ---
    IF TIMER - takt# >= .18 OR TIMER < takt# THEN
        CALL PomakniNeprijatelje
        takt# = TIMER
    END IF

    IF gotovo% = 1 THEN
        CALL GameOver
        EXIT DO
    END IF
LOOP

END

' ==========================================================
SUB Uvod
    SCREEN 0: WIDTH 80, 25: CLS
    COLOR 14
    LOCATE 2, 28: PRINT "*** LUNINA POTRAGA v2 ***"
    COLOR 6
    LOCATE 5, 32: PRINT ".-------."
    LOCATE 6, 32: PRINT "/         \"
    LOCATE 7, 32: PRINT "|  O   O  | "
    LOCATE 8, 32: PRINT "|   ---   |"
    LOCATE 9, 32: PRINT " \  \_/  /"
    LOCATE 10, 32: PRINT " /|     |\"
    LOCATE 11, 32: PRINT "/ |_____| \"
    COLOR 11
    LOCATE 14, 8: PRINT "Luna skakuce galaksijom i trazi 5 predmeta."
    LOCATE 15, 8: PRINT "Crvena Omega stvorenja (Q) je love"
    LOCATE 16, 8: PRINT "Ako je dotaknu, gubi zivot."
    COLOR 15
    LOCATE 19, 8: PRINT "STRELICE = skok     ESC = izlaz"
    COLOR 10
    LOCATE 22, 8: PRINT "za pocetak pritisni bilo koju tipku..."
    DO: LOOP WHILE INKEY$ = ""
END SUB

' ==========================================================
SUB InitMapa
    mapa$(2) = "                            2    "
    mapa$(3) = "     xxxxx         xxxxx          "
    mapa$(4) = "                          1      "
    mapa$(5) = "        xxxx     xxxx             "
    mapa$(6) = "                                 "
    mapa$(7) = "   3         xxxxxx        xxxx   "
    mapa$(8) = "                              5   "
    mapa$(9) = "     xxxx          xxxx           "
    mapa$(10) = "                                "
    mapa$(11) = "          4        xxxxx         "
    mapa$(12) = "                                "
    mapa$(13) = "     xxxxx          xxxxx        "
    mapa$(14) = "                                "

    FOR r% = 1 TO 15
        mapa$(r%) = LEFT$(mapa$(r%) + SPACE$(40), 40)
        FOR c% = 1 TO 40
            IF MID$(mapa$(r%), c%, 1) = "x" THEN MID$(mapa$(r%), c%, 1) = zid$
        NEXT
        MID$(mapa$(r%), 1, 1) = zid$
        MID$(mapa$(r%), 40, 1) = zid$
    NEXT
    mapa$(1) = STRING$(40, zid$)
    mapa$(15) = STRING$(40, zid$)
END SUB

' ==========================================================
SUB CrtajMapu
    FOR r% = 1 TO 15
        FOR c% = 1 TO 40
            LOCATE r%, c%
            CALL CrtajCel(r%, c%)
        NEXT
    NEXT
END SUB

' ==========================================================
SUB CrtajCel (r%, c%)
    z$ = MID$(mapa$(r%), c%, 1)
    SELECT CASE z$
        CASE zid$: COLOR 8: PRINT zid$;
        CASE "1": COLOR 11: PRINT CHR$(4);
        CASE "2": COLOR 14: PRINT CHR$(15);
        CASE "3": COLOR 10: PRINT "o";
        CASE "4": COLOR 13: PRINT CHR$(5);
        CASE "5": COLOR 12: PRINT CHR$(3);
        CASE ELSE: COLOR 7: PRINT " ";
    END SELECT
    COLOR 7
END SUB

' ==========================================================
SUB CrtajEntitete
    FOR i% = 1 TO ne%
        LOCATE ey%(i%), ex%(i%): COLOR 12: PRINT "Q";
    NEXT
    LOCATE py%, px%: COLOR 6: PRINT CHR$(2);
    COLOR 7
END SUB

' ==========================================================
SUB PomakniNeprijatelje
    FOR i% = 1 TO ne%
        LOCATE ey%(i%), ex%(i%): CALL CrtajCel(ey%(i%), ex%(i%))

        dx% = SGN(px% - ex%(i%))
        dy% = SGN(py% - ey%(i%))
        pom% = 0

        IF RND < .75 THEN
            IF dx% <> 0 AND MID$(mapa$(ey%(i%)), ex%(i%) + dx%, 1) <> zid$ THEN
                ex%(i%) = ex%(i%) + dx%: pom% = 1
            END IF
            IF pom% = 0 AND dy% <> 0 THEN
                IF MID$(mapa$(ey%(i%) + dy%), ex%(i%), 1) <> zid$ THEN ey%(i%) = ey%(i%) + dy%
            END IF
        ELSE
            IF dy% <> 0 AND MID$(mapa$(ey%(i%) + dy%), ex%(i%), 1) <> zid$ THEN
                ey%(i%) = ey%(i%) + dy%: pom% = 1
            END IF
            IF pom% = 0 AND dx% <> 0 THEN
                IF MID$(mapa$(ey%(i%)), ex%(i%) + dx%, 1) <> zid$ THEN ex%(i%) = ex%(i%) + dx%
            END IF
        END IF

        LOCATE ey%(i%), ex%(i%): COLOR 12: PRINT "Q";

        IF ex%(i%) = px% AND ey%(i%) = py% THEN CALL Sudar
    NEXT

    LOCATE py%, px%: COLOR 6: PRINT CHR$(2);
    COLOR 7
END SUB

' ==========================================================
SUB Sudar
    SOUND 300, 2: SOUND 200, 2: SOUND 120, 3         
    zdravlje% = zdravlje% - 1
    CALL Hud

    LOCATE py%, px%: CALL CrtajCel(py%, px%)          
    px% = 2: py% = 2
    LOCATE py%, px%: COLOR 6: PRINT CHR$(2);
    COLOR 7

    IF zdravlje% <= 0 THEN
        gotovo% = 1
    ELSE
        t# = TIMER
        DO: LOOP UNTIL TIMER - t# >= .4               
    END IF
END SUB

' ==========================================================
SUB Hud
    COLOR 14: LOCATE 17, 2: PRINT "Predmeti:"; STR$(skupljeno%); " /"; STR$(ukupno%); "    "
    LOCATE 17, 24: COLOR 12: PRINT "Zivoti: ";
    IF zdravlje% > 0 THEN
        FOR i% = 1 TO zdravlje%: PRINT CHR$(3); " "; : NEXT
    END IF
    PRINT "      "
    COLOR 11: LOCATE 18, 2: PRINT "STRELICE=skok  ESC=izlaz   Bjezi od Q stvorenja!"
    COLOR 7
END SUB

' ==========================================================
SUB Poklon (n%)
    FOR i% = 19 TO 23
        LOCATE i%, 2: PRINT SPACE$(74)
    NEXT
    SELECT CASE n%
        CASE 1
            LOCATE 19, 2: COLOR 11: PRINT "Luna je nasla SVJETLECI KRISTAL!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: mali svjetlosni mac koji sjaji u mraku"
        CASE 2
            LOCATE 19, 2: COLOR 14: PRINT "Luna je nasla ZVJEZDANU KARTU!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: karta otkriva skriveni svemirski brod"
        CASE 3
            LOCATE 19, 2: COLOR 10: PRINT "Luna je nasla MALOG DROIDA!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: droid ce sada pomagati u potrazi"
        CASE 4
            LOCATE 19, 2: COLOR 13: PRINT "Luna je nasla CAROBNI CVIJET!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: cvijet joj daje snagu za skakutanje"
        CASE 5
            LOCATE 19, 2: COLOR 12: PRINT "Luna je nasla ZLATNU ZVIJEZDU!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: postala je cuvarica galaksije"
    END SELECT
    COLOR 14: LOCATE 22, 2: PRINT "Pritisni tipku i trazi dalje..."
    DO: LOOP WHILE INKEY$ = ""
    FOR i% = 19 TO 23
        LOCATE i%, 2: PRINT SPACE$(74)
    NEXT
END SUB

' ==========================================================
SUB Pobjeda
    CLS
    PLAY "O3 T140 c e g O4 c e g > c"
    COLOR 14: LOCATE 8, 25: PRINT "*  *  *  BRAVO, LUNA je uspjela!  *  *  *"
    COLOR 11: LOCATE 11, 18: PRINT "Sakupila je svih 5 predmeta i pobjegla stvorenjima!"
    LOCATE 13, 18: PRINT "Galaksija je sigurna. Potraga je uspjela!"
    COLOR 10: LOCATE 18, 25: PRINT "Pritisni tipku za kraj..."
    DO: LOOP WHILE INKEY$ = ""
END SUB

' ==========================================================
SUB GameOver
    CLS
    PLAY "O3 T120 g e c O2 g e c"
    COLOR 12: LOCATE 9, 30: PRINT "LUNA JE OSTALA BEZ ZIVOTA!"
    COLOR 15: LOCATE 12, 22: PRINT "Omega stvorenja su ovaj put bila prebrza."
    LOCATE 13, 22: PRINT "Predmeta skupljeno:"; STR$(skupljeno%); " /"; STR$(ukupno%)
    COLOR 10: LOCATE 18, 25: PRINT "Pritisni tipku za kraj..."
    DO: LOOP WHILE INKEY$ = ""
END SUB
