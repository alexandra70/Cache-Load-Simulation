# Cache-Load-Simulation

In Columnar Transposition Cipher se doreste criptarea textului primit ca arument
in functie de key - care era deja transformata intr un vector de ordine.

Mod de implementare:
    Am doua bucle: Una pentru a parcurge vectorul de ordine.
                   Inca una pentru parcurgerea coloanei(orientativ).

                   In timp ce parcurg vectorul de ordine - iau valoarea curenta din vector
                   v[0], dupa care v[1] si tot asa pana la final, valoarea respectiva imi
                   da coloana, de pe aceasta coloana eu trebuie sa iau toate
                   char urile si sa le adaug in stringul pe care il voi returna
                   Pacurgerea stringului final se face cu un contor a carui 
                   valoare se va inc dupa fiecare adaugare.
                   Urmatorul element de pe coloana se va determina dupa
                   formula :: coloana + contor_coloana * lungime_key;
                   In cazul in care formula de mai sus returneaza un numar
                   mai mare decat lungimea plain textului, atunci coloana a
                   fost procesata si se va continua pana cand tot vectorul de ordine
                   va fi complet parcurs. La final sirul rezulat este si el complet
                   format.


Cache Load Simulation:

                In primul rand am urmat algoritmul exact:

                    1.Calculăm tag-ul pentru adresa de la care vrem să obținem date
                    2.Iterăm prin tag-urile fiecărei linii. Dacă am găsit o linie care
                    are asociat tag-ul calculat la pasul 1, calculăm offset-ul din 
                    cadrul liniei pentru octetul pe care vrem să-l copiem în registru
                    și aducem acest octet din cache în registru. (Offset-ul e 
                    reprezentat de cei mai puțin semnificativ 3 biți din adresa
                    octetului, cei pe care îi tăiem când calculăm tag-ul.)
                    3.Dacă nu am găsit o linie care are asociat tag-ul calculat la pasul 1, 
                    trebuie să aducem 8 octeți consecutivi din memorie într-o linie a cache-ului,
                    unul din acești octeți fiind cel dorit (CACHE MISS). Linia pe care trebuie să o 
                    scriem la acest pas e cea cu index-ul to_replace . După ce a fost adusă linia în 
                    cache, registrul trebuie scris la fel ca la pasul precedent.

                Particularitatii de implementare:
                     A fost greu de implemetntat, mi a fost greu sa inteleg exact ce
                     trebuie sa fac, a durat mult, si doua teste sunt sigure inca incorecte
                     o sa mai testez odata dupa ce apar mai multe despre cheker.

                     In principu nu e un task imposibil, chiar din contra, numai ca
                     sunt prea multe lucruri de care trebuie sa tii cont avand in vedere
                     ca se doreste a fi scris in assembly.
                     
                     Deci pt a obtine tagul, respectiv offsetul fac shiftari la 
                     stanga si la dreapa in functie de nevoie. Am trei variabile
                     globale, am incercat sa nu folosesc, numai ca ma incurcam in 
                     push si pop, deci am ales sa fac in felul uramtor.
                     EXPLICATII PT COD:
                        offset - tin minte offsetul practic (29(de biti de zero) (bit bit bit))
                        tag  = tagul e pe 32 biti de va fi mereu tag = (((0 0 0) si 29(de biti))
                        i = linia, ca in enunt(unde am gasit tagul)

                    cauta_in_tags + linii_tags:
                        Parcurg toate tagurile si vad care se potriveste cu ce gasesc
                        la adresa[tag] = unde am pus tagul cand l am calculat.
                        Tot aici pun in [i] linia la care gasesc byte ul de care am nevoie.

                    suprascrie_linie_cache + line_loop:
                        Aduc din memorie prin folosire lui tag (cum scrie in algoritm)
                        si copletez linia indicata de to_replace [ebp + 24].

                    take_from_cache:
                        Caut de unde din cache trebuie sa aduc octetul si il pun in rezulatul final.

                    func: 
                        Labelul principal cumva, aici calculez tag ul si offsetul, de aici
                        pornesc cautare tagului gasit.

                    tag_gasit + tag_negasit:
                        Le am pastrat mai mult sa diferentieze puntin actiunile pe care
                        urmaeazasa le fac. Pentu tag_gasit -> mai ramne doar sa caut in
                        memoria cache, deoarece deja exista tagul calculat in matrice
                        tags.
                        Iar pentru tag_negasit trebuie sa mai fac un pas si anume
                        sa iau din memorie si sa pun in linia indicata din cache, si din
                        matrice tags octetii gasiti in memorie la adresa  [ebp + 20] -- address.

                    stop:
                        Se restaureaza registrele si se termina functia.




