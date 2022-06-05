"""
    Application python pour le projet BDR Camping
    CAEL Benoît - GUIBLIN Nicolas 
"""

# Import des fonctions client et reservation
import psycopg2 # import pour gerer la bdd
import config # Config pour se connecter a la bdd
import lib # Notre lib perso avec des fonctions qui ne nécéssitent pas l'appel de hello()
from datetime import datetime, timedelta # Pour travailler avec des dates

# Connexion a la base de données
con = config.connect()
sql = con.cursor() # création du cursor

# Fonction principale avec le menu
def hello():
    print("""
        +==================================================+
        |                                                  |
        | Bonjour et bienvenue sur l'application camping ! |
        |                                                  |
        | 1) Effectuer une reservation                     |
        |                                                  |
        | 2) Supprimer une reservation                     |
        |                                                  |
        | 3) Voir les reservations                         |
        |                                                  |
        | 4) Consulter l'historique                        |
        |                                                  |
        | 5) Ajouter un emplacement                        |
        |                                                  |
        | 6) Ajouter une saison                            |
        |                                                  |
        | 99) Quitter                                      |
        |                                                  |
        +==================================================+
    """)
    choice = int(input("Saisissez une option > ")) # Appel de la fonction choice_select pour traiter l'input

    if choice == 1: add_reservation()
    elif choice == 2: delete_reservation()
    elif choice == 3: show_reservation()
    elif choice == 4: show_historique()
    elif choice == 5: add_emplacement()
    elif choice == 6: saison()
    elif choice == 99: exit("Merci et au revoir")
    else: exit("Erreur")



# Fonction qui permet d'ajouter une reservation
def add_reservation():
    sql.execute(""" SELECT COUNT(id_emplacement) FROM "Emplacement" WHERE id_emplacement NOT IN (SELECT id_emplacement FROM "Sejour") """)
    result = sql.fetchone()
    result = result[0]
    
    if result == 0: # Si plus aucun emplacement
        print("[-] Le camping ne possède plus aucun emplacement de libre")
        hello()
    else:
        print("Liste de tous les emplacements libre")
        lib.show_emplacement() # On affiche les emplacements libre
        id_emplacement = int(input("Quel emplacement souhaitez vous reserver (selectionnez un id) > "))

        # On demande pour quel client on souhaite effectuer une réservation
        lib.show_personne()
        wich = int(input("Pour quel client souhaitez vous effectuer une reservation ? (saisissez l'id ou 0 pour entrer un nouveau client) > "))
        
        # Si la personne est pas enregistré alors on l'enregistre
        if wich == 0: add_personne() 

        # On compte le nombre de réservation
        count = lib.count_reservation(wich)

        if count >= 2:
            print("Le quota de réservation a été atteint pour ce client !")
            hello()
        
        # Debut de séjour
        debut = input("Date de début du séjour (YYYY/MM/DD) > ")

        # Si c'est pas fait une semaine a l'avance
        if lib.days_between_date(debut) < 7:
            print("[-] La réservation doit être effectué 1 semaine à l'avance")
            hello()
        
        duree = int(input("Durée du séjour (en jour) > "))

        # Reglement etc .. 
        if duree <= 3:
            print("/!\ Le client doit régler le séjour maintenant !")
            sejour_paye = True
        else:
            sejour_paye = False

        # Calcule coefficient + montant acompte
        coeff = lib.calc_coeff(duree)
        coeff_saison = lib.get_saison_coeff(debut)


        montant_acompte = duree * lib.get_price_per_day_emplacement(id_emplacement)
        montant_acompte = montant_acompte * (1 + coeff_saison/100)
        montant_acompte = montant_acompte * (1 - coeff/100)
        acompte = True

        print("/!\ Un acompte de 10% doit être payé avant la réservation !")
        print("[i] Ce montant correspond a ",montant_acompte," €")

        if count == 0:
            sql.execute(""" INSERT INTO "Client"(id_personne) VALUES(%s) """, [wich])

        sql.execute(""" INSERT INTO "Sejour"(date_debut, duree, coefficient_remise, acompte_paye, sejour_paye, id_client, id_emplacement) 
                        VALUES(%s,%s,%s,%s,%s,%s,%s)
                    """, [debut, duree, coeff, acompte, sejour_paye, wich, id_emplacement])

        sql.execute(""" SELECT id_sejour FROM "Sejour" ORDER BY id_sejour DESC LIMIT 1 """)
        id_sejour = sql.fetchone()
        id_sejour = id_sejour[0]
        sql.execute(""" INSERT INTO "Sejour_Saison"(id_sejour, id_saison,nb_jours) VALUES(%s,%s,%s) """, [id_sejour, lib.get_saison(debut), duree])

        answer  = int(input("Voulez vous ajouter des personnes à votre séjour ? (O/N) > "))

        sql.execute(""" SELECT nb_place FROM "Emplacement" """)
        nb_place = sql.fetchone()
        nb_place = nb_place[0] - 1

        while answer == "O" and nb_place != 0:
            p = int(input("Quel personne souhaitez vous ajouter à la reservation ? (saisissez l'id) > "))

            lib.show_personne_not_int_reservation()

            sql.execute(""" INSERT INTO "Personne_Sejour"(id_personne, id_sejour) VALUES(%s,%s) """, [p,id_sejour])
            answer = int(input("Voulez vous ajoutez d'autres personnes à votre séjour ? Restant : " + nb_place + " (O/N) > "))

        print("[+] Le séjour a bien été enregistré")
        hello() #Rappel du menu principal


# Fonction qui permet de setup une saison, ete ou hors saison
def saison():
    nom = input("Nom > ")
    coeff = int(input("Coefficient en % > "))
    debut = input("Debut (YYYY/MM/DD) > ")
    fin = input("Fin (YYYY/MM/DD) > ")
    sql.execute(""" INSERT INTO "Saison"(nom, coefficient_saison, debut, fin) VALUES(%s,%s,%s,%s) """, (
        nom, coeff, debut, fin
    ))
    print("[+] La saison a bien été enregistrée")
    hello()

# Fonction qui permet d'ajouter un emplacement
def add_emplacement():
    print("Ajouter un emplacement")
    name = input("Nom de l'emplacement > ")
    surface = input("Surface de l'emplacement en m² > ")
    prix = input("Prix par jour > ")
    nb_place = input("Nombre de places > ")

    print(""" Quel est le type d'emplacement 
    1) Tente 
    2) Mobilehome
    3) Campingcar
    """)
    type_emplacement = int(input("> "))
    sql.execute(""" INSERT INTO "Emplacement"(libelle, surface, prix_jour, nb_place) VALUES(%s,%s,%s,%s) """ ,(
        name, surface, prix, nb_place
    ))
    
    sql.execute(""" SELECT id_emplacement FROM "Emplacement" ORDER BY id_emplacement DESC LIMIT 1 """)
    id_emplacement = sql.fetchone()
    id_emplacement = id_emplacement[0]

    if type_emplacement == 1: # Si l'emplacement est une tente
        sql.execute(""" INSERT INTO "Tente"(id_emplacement) VALUES(%s) """, [id_emplacement])
        print("[+] Emplacement ajouté avec succès !")

    elif type_emplacement == 2: # Si l'emplacement est un mobilehome
        store = input("Est-ce que le mobilehome possède un store exterieur ? (O/N)")

        if store == "O": store = True
        elif store == "N": store = False
        else: exit("Erreur : option non connue")

        sql.execute(""" INSERT INTO "Mobilhome"(id_emplacement, store_exterieur) VALUES(%s,%s) """, [id_emplacement, store])
        print("[+] Emplacement ajouté avec succès !")
    elif type_emplacement == 3: # Si l'emplacement est un campingcar
        elec = input("Est-ce que l'emplacement du campingcar est relié en électricité ? (O/N)")

        if elec == "O": elec = True
        elif elec == "N": elec = False
        else: exit("Erreur : option non connue")

        sql.execute(""" INSERT INTO "Campingcar"(id_emplacement, electricite) VALUES(%s,%s) """, [id_emplacement, elec])
        print("[+] Emplacement ajouté avec succès !")
    else: exit("Erreur : emplacement inconnu")

    hello()

# Permet de voir les clients
def delete_client():
    print("Supprimer un client")
    id_client = input("Id du client > ")
    delete = con.cursor()
    delete.execute("DELETE FROM personne WHERE id_personne = %s", id_client)
    print("[+] Le client a bien été supprimé ")
    hello()

# Fonction qui permet d'ajouter une personne à la bdd
def add_personne():
    print("Ajouter une personne")
    nom = input("Nom > ")
    prenom = input("Prenom > ")
    email = input("Email > ")
    nb_rue = input("Numéro rue > ")
    adresse = input("Adresse > ")
    code = input("Code postal > ")
    ville = input("Ville > ")

    insert = con.cursor()
    insert.execute(""" INSERT INTO "Personne"(nom,prenom,mail,numero_rue,rue,code_postal,ville) VALUES(%s,%s,%s,%s,%s,%s,%s)""",(
        nom, prenom, email, nb_rue, adresse, code, ville
    ))

    print("[+] Client ajouté avec succès !")

# Fonction qui affiche l'historique
def show_historique():
    print("[-] Option non disponible pour cette version :( ...")
    hello()

# Fonction qui affiche les reservations
def show_reservation():
    sql.execute(""" SELECT * FROM "Sejour" """)
    hello()

# Fonction qui supprime une reservation
def delete_reservation():
    sql.execute(""" SELECT * FROM "Emplacement" """)
    for r in sql.fetchall():
        print(r)
    id_choice = int(input("Saisissez un id pour supprimer une réservation > "))
    sql.execute(""" DELETE FROM "Emplacement" WHERE id_emplacement = %s """, [id_choice])
    print("[+] Emplacement supprimé ! ")
    hello()


hello()
# fuck()

config.destroy(con) # On ferme la connexion