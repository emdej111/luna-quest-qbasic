' ==========================================================
'  LUNINA POTRAGA  -  mini avantura u QBASIC / QB64
'  Djevojcica s dugom smedjom kosom i naocalama skakuce
'  po fantasy / star-wars svijetu i trazi predmete.
'  Za svaki nadjeni predmet dobije poklon koji je motivira.
'
'  Upravljanje:  STRELICE = skakutanje    ESC = izlaz
' ==========================================================

DECLARE SUB Uvod ()
DECLARE SUB InitMapa ()
DECLARE SUB CrtajSve ()
DECLARE SUB CrtajCel (r%, c%)
DECLARE SUB Poklon (n%)
DECLARE SUB Pobjeda ()

DIM SHARED px%, py%, skupljeno%, ukupno%
DIM SHARED mapa$(1 TO 15)

RANDOMIZE TIMER
ukupno% = 5
skupljeno% = 0

CALL Uvod
CALL InitMapa

px% = 2: py% = 2          ' pocetni polozaj djevojcice (stupac, red)

CLS
CALL CrtajSve

' ---------------- GLAVNA PETLJA ----------------
DO
    tipka$ = ""
    DO
        tipka$ = INKEY$
    LOOP WHILE tipka$ = ""

    IF tipka$ = CHR$(27) THEN EXIT DO            ' ESC

    nx% = px%: ny% = py%
    IF LEN(tipka$) = 2 THEN
        k$ = RIGHT$(tipka$, 1)
        IF k$ = CHR$(72) THEN ny% = py% - 1      ' gore
        IF k$ = CHR$(80) THEN ny% = py% + 1      ' dolje
        IF k$ = CHR$(75) THEN nx% = px% - 1      ' lijevo
        IF k$ = CHR$(77) THEN nx% = px% + 1      ' desno
    END IF

    polje$ = MID$(mapa$(ny%), nx%, 1)

    IF polje$ <> CHR$(178) THEN                  ' ako nije zid
        px% = nx%: py% = ny%

        IF polje$ >= "1" AND polje$ <= "5" THEN  ' nasla predmet
            n% = VAL(polje$)
            MID$(mapa$(py%), px%, 1) = " "
            skupljeno% = skupljeno% + 1
            CALL Poklon(n%)
        END IF

        CALL CrtajSve

        IF skupljeno% = ukupno% THEN
            CALL Pobjeda
            EXIT DO
        END IF
    END IF
LOOP

END

' ==========================================================
SUB Uvod
    SCREEN 0: WIDTH 80, 25: CLS
    COLOR 14
    LOCATE 2, 28: PRINT "*** LUNINA POTRAGA ***"
    COLOR 6
    LOCATE 5, 30: PRINT ".-" + STRING$(5, "-") + "-."
    LOCATE 6, 30: PRINT "/         \"
    LOCATE 7, 30: PRINT "|  O   O  |   <- naocale"
    LOCATE 8, 30: PRINT "|   ---   |"
    LOCATE 9, 30: PRINT " \  \_/  /"
    LOCATE 10, 30: PRINT " /|     |\"
    LOCATE 11, 30: PRINT "/ |     | \   <- duga smedja kosa"
    LOCATE 12, 30: PRINT "  |_____|"
    COLOR 11
    LOCATE 15, 10: PRINT "Ovo je Luna. Skakuce po dalekoj galaksiji i trazi"
    LOCATE 16, 10: PRINT "5 skrivenih predmeta. Svaki joj donosi novi poklon!"
    COLOR 15
    LOCATE 19, 10: PRINT "Upravljanje:  STRELICE = skok     ESC = izlaz"
    COLOR 10
    LOCATE 22, 10: PRINT "Pritisni bilo koju tipku za pocetak..."
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

    ' izjednaci sirinu, zamijeni 'x' zidom i zapecati rub
    FOR r% = 1 TO 15
        mapa$(r%) = LEFT$(mapa$(r%) + SPACE$(40), 40)
        FOR c% = 1 TO 40
            IF MID$(mapa$(r%), c%, 1) = "x" THEN MID$(mapa$(r%), c%, 1) = CHR$(178)
        NEXT
        MID$(mapa$(r%), 1, 1) = CHR$(178)
        MID$(mapa$(r%), 40, 1) = CHR$(178)
    NEXT
    mapa$(1) = STRING$(40, CHR$(178))
    mapa$(15) = STRING$(40, CHR$(178))
END SUB

' ==========================================================
SUB CrtajSve
    FOR r% = 1 TO 15
        FOR c% = 1 TO 40
            LOCATE r%, c%
            CALL CrtajCel(r%, c%)
        NEXT
    NEXT

    ' djevojcica (smedja = kosa)
    LOCATE py%, px%: COLOR 6: PRINT CHR$(2);

    COLOR 14
    LOCATE 17, 2: PRINT "Nasla si:"; STR$(skupljeno%); " /"; STR$(ukupno%); "   "
    COLOR 11
    LOCATE 18, 2: PRINT "STRELICE = skok    ESC = izlaz"
    COLOR 7
END SUB

' ==========================================================
SUB CrtajCel (r%, c%)
    z$ = MID$(mapa$(r%), c%, 1)
    SELECT CASE z$
        CASE CHR$(178): COLOR 8: PRINT CHR$(178);   ' zid
        CASE "1": COLOR 11: PRINT CHR$(4);           ' kristal
        CASE "2": COLOR 14: PRINT CHR$(15);          ' zvjezdana karta
        CASE "3": COLOR 10: PRINT "o";               ' droid
        CASE "4": COLOR 13: PRINT CHR$(5);           ' cvijet
        CASE "5": COLOR 12: PRINT CHR$(3);           ' zlatno srce
        CASE ELSE: COLOR 7: PRINT " ";
    END SELECT
    COLOR 7
END SUB

' ==========================================================
SUB Poklon (n%)
    FOR i% = 19 TO 23
        LOCATE i%, 2: PRINT SPACE$(74)
    NEXT

    COLOR 15
    SELECT CASE n%
        CASE 1
            LOCATE 19, 2: COLOR 11: PRINT "Nasla si SVJETLECI KRISTAL!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: mali svjetlosni mac koji sjaji u mraku."
        CASE 2
            LOCATE 19, 2: COLOR 14: PRINT "Nasla si ZVJEZDANU KARTU!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: karta otkriva skriveni svemirski brod."
        CASE 3
            LOCATE 19, 2: COLOR 10: PRINT "Nasla si MALOG DROIDA!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: droid ce ti sada pomagati u potrazi."
        CASE 4
            LOCATE 19, 2: COLOR 13: PRINT "Nasla si CAROBNI CVIJET!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: cvijet ti daje novu snagu za skakutanje."
        CASE 5
            LOCATE 19, 2: COLOR 12: PRINT "Nasla si ZLATNU ZVIJEZDU!"
            LOCATE 20, 2: COLOR 15: PRINT "Poklon: postala si prava cuvarica galaksije."
    END SELECT

    COLOR 14
    LOCATE 22, 2: PRINT "Pritisni tipku i trazi dalje..."
    DO: LOOP WHILE INKEY$ = ""

    FOR i% = 19 TO 23
        LOCATE i%, 2: PRINT SPACE$(74)
    NEXT
END SUB

' ==========================================================
SUB Pobjeda
    CLS
    COLOR 14
    LOCATE 8, 25: PRINT "*  *  *  BRAVO, LUNA!  *  *  *"
    COLOR 11
    LOCATE 11, 20: PRINT "Sakupila si svih 5 predmeta u galaksiji!"
    LOCATE 13, 20: PRINT "Kristal, karta, droid, cvijet i zlatna zvijezda"
    LOCATE 14, 20: PRINT "sada su tvoji. Potraga je uspjela!"
    COLOR 10
    LOCATE 18, 25: PRINT "Pritisni tipku za kraj..."
    DO: LOOP WHILE INKEY$ = ""
END SUB
