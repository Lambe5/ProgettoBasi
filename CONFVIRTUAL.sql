DROP DATABASE IF EXISTS CONFVIRTUAL;
CREATE DATABASE CONFVIRTUAL;
USE CONFVIRTUAL;

SET GLOBAL event_scheduler = ON;

CREATE TABLE UTENTE(
		Username 	 varchar(30) primary key,
        Password 	 varchar(30),
		Nome 		 varchar(30),
		Cognome 	 varchar(30),
		LuogoNascita varchar(30),
		DataNascita	 Date
        
) ENGINE = INNODB;
 
CREATE TABLE PRESENTER(
		UsernameUtente varchar(30) primary key,
		NomeUni 	   varchar(30),
		NomeDip 	   varchar(30),
		CV 			   varchar(30),
		Foto 		   BLOB,
        
        foreign key(UsernameUtente) references UTENTE(Username)
        
) ENGINE = INNODB;
 
CREATE TABLE SPEAKER(
		UsernameUtente varchar(30) primary key,
		NomeUni 	   varchar(30),
		NomeDip 	   varchar(30),
		CV 			   varchar(30),
		Foto 		   BLOB,
        
        foreign key(UsernameUtente) references UTENTE(Username)
        
) ENGINE = INNODB;
 
CREATE TABLE AMMINISTRATORE(
		UsernameUtente varchar(30) primary key,
		
        foreign key(UsernameUtente) references UTENTE(Username)
        
) ENGINE = INNODB;
 
CREATE TABLE SPONSOR(
		Nome 	varchar(30) primary key,
		ImgLogo BLOB
        
) ENGINE = INNODB;
 
CREATE TABLE CONFERENZA(
		Acronimo 	 varchar(30),
		AnnoEdizione YEAR,
		ImgLogo 	 BLOB,
		Nome 		 varchar(30) NOT NULL,
		Svolgimento  ENUM("Attiva", "Completata") DEFAULT "Attiva",
		
        primary key(Acronimo, AnnoEdizione)
        
) ENGINE = INNODB;
 
CREATE TABLE SPONSORIZZAZIONE(
		NomeSponsor 		   varchar(30),
		AcronimoConferenza     varchar(30),
		AnnoEdizioneConferenza YEAR,
		Importo 			   float NOT NULL, 
		
        primary key(NomeSponsor, AcronimoConferenza, AnnoEdizioneConferenza),
		
        foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione) on delete cascade,
		foreign key(NomeSponsor) references SPONSOR(Nome) on delete cascade
        
) ENGINE = INNODB;
 # Permette di inserire un ACRONIMO anche se non presente nella conferenza
CREATE TABLE PROGRAMMA_GIORNALIERO(
		Id varchar(10), 
		AcronimoConferenza varchar(30) references CONFERENZA(Acronimo) on delete cascade,
        AnnoEdizioneConferenza varchar(30) references CONFERENZA(AnnoEdizione) on delete cascade,
		Data 			   date,
		
        primary key(Id)
		        
) ENGINE = INNODB;
 
CREATE TABLE SESSIONE(
		Codice 			 varchar(10)   primary key,
		IdProgramma 	 varchar(10) NOT NULL references PROGRAMMA_GIORNALIERO(Id) on delete cascade,
		LinkTeams 		 varchar(100),
		NumPresentazioni int DEFAULT 0,
		OraFine 		 time,
		OraIni 			 time,
		Titolo 			 varchar(100)
        
) ENGINE = INNODB; 
 
CREATE TABLE MESSAGGIO(
		CodiceSessione  varchar(10),
		Timestamp 	    float,
		UsernameUtente  varchar(30)   NOT NULL,
		Testo 		    varchar(500),
		DataInserimento date,
		
        primary key (CodiceSessione, Timestamp),
        
        foreign key(CodiceSessione) references SESSIONE(Codice) on delete cascade,
        foreign key(UsernameUtente) references UTENTE(Username)
        
) ENGINE = INNODB;
 
CREATE TABLE PRESENTAZIONE(
		Codice 		   varchar(10),
		CodiceSessione varchar(10),
		NumSequenza    int,
		OraFine 	   time,
		OraIni 		   time,
		
        primary key(Codice, CodiceSessione),
        
        foreign key(CodiceSessione) references SESSIONE(Codice) on delete cascade
        
) ENGINE = INNODB;
 
 CREATE TABLE ARTICOLO(
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		Numpagine 		    		int,
		filePDF 		    		BLOB,
		Titolo 			    		varchar(100),
		StatoSvolgimento    		ENUM("Coperto", "NonCoperto") DEFAULT "NonCoperto",
		UsernamePresenter   		varchar(30),
        
		primary key(CodicePresentazione, CodiceSessionePresentazione),
        
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione) on delete cascade,
        foreign key(UsernamePresenter) references PRESENTER(UsernameUtente)
        
) ENGINE = INNODB;
 
CREATE TABLE TUTORIAL(
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		Titolo 						varchar(100),
		Abstract 					varchar(500), 
		
        primary key(CodicePresentazione, CodiceSessionePresentazione),
		
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione) on delete cascade
) ENGINE = INNODB; 
 
CREATE TABLE AUTORE(
		ID 		int 		primary key,
		Nome 	varchar(30) NOT NULL,
		Cognome varchar(30) NOT NULL
) ENGINE = INNODB;
 
CREATE TABLE LISTA_AUTORI(
		IdAutore 			   int,
		CodiceArticolo 		   varchar(10),
		CodiceSessioneArticolo varchar(10),
        
		primary key(IdAutore, CodiceArticolo, CodiceSessioneArticolo),
        
		foreign key(CodiceArticolo, CodiceSessioneArticolo) references ARTICOLO(CodicePresentazione, CodiceSessionePresentazione) on delete cascade, 
		foreign key(IdAutore) references AUTORE(ID) on delete cascade
        
) ENGINE = INNODB;
 
CREATE TABLE PAROLA_CHIAVE(
		CodiceArticolo varchar(10) references ARTICOLO(Codice) on delete cascade,
		Parola 		   varchar(20), 
        primary key(CodiceArticolo, Parola)
        
) ENGINE = INNODB;
 
CREATE TABLE LISTA_PRESENTAZIONI_FAVORITE(
		UsernameUtente 				varchar(30),
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		
        primary key(UsernameUtente, CodicePresentazione, CodiceSessionePresentazione), 
		
        foreign key(UsernameUtente) references UTENTE(Username),
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione) on delete cascade
        
) ENGINE = INNODB;
 
CREATE TABLE REGISTRAZIONE(
		UsernameUtente 		   varchar(30),
		AcronimoConferenza 	   varchar(30),
		AnnoEdizioneConferenza YEAR,
		
        primary key(UsernameUtente, AcronimoConferenza, AnnoEdizioneConferenza), 
		
        foreign key(UsernameUtente) references UTENTE(Username),
        foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione) on delete cascade

) ENGINE = INNODB;

CREATE TABLE CREAZIONE(
		UsernameAmministratore varchar(30),
		AcronimoConferenza 	   varchar(30),
		AnnoEdizioneConferenza YEAR,
		
        primary key(UsernameAmministratore, AcronimoConferenza, AnnoEdizioneConferenza),
        
		foreign key(UsernameAmministratore) references AMMINISTRATORE(UsernameUtente),
        foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione) on delete cascade
        
) ENGINE = INNODB;
 
CREATE TABLE VALUTAZIONE(
		UsernameAmministratore 		varchar(30),
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		Voto 						int 		CHECK(Voto >= 0 and Voto <= 10),
		Note 						varchar(50), 
		
        primary key(UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione), 
		
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione) on delete cascade, 
		foreign key(UsernameAmministratore) references AMMINISTRATORE(UsernameUtente)
        
) ENGINE = INNODB; 
 
 CREATE TABLE INFO_AGGIUNTIVE(
		UsernameSpeaker 	   varchar(30),
		CodiceTutorial 		   varchar(10),
		CodiceSessioneTutorial varchar(10),
		LinkWeb 			   varchar(100),
		Descrizione 		   varchar(500),
        
		primary key(UsernameSpeaker, CodiceTutorial, CodiceSessioneTutorial),
        
        foreign key(UsernameSpeaker) references SPEAKER(UsernameUtente),
		foreign key(CodiceTutorial, CodiceSessioneTutorial) references TUTORIAL(CodicePresentazione, CodiceSessionePresentazione) on delete cascade
        
) ENGINE = INNODB;
 
CREATE TABLE PRESENTAZIONE_TUTORIAL(
		UsernameSpeaker 		varchar(30),
		CodiceTutorial 			varchar(10),
		CodiceSessioneTutorial 	varchar(10),
		
        primary key(UsernameSpeaker, CodiceTutorial, CodiceSessioneTutorial),
        
		foreign key(UsernameSpeaker) references SPEAKER(UsernameUtente),
        foreign key(CodiceTutorial, CodiceSessioneTutorial) references TUTORIAL(CodicePresentazione, CodiceSessionePresentazione) on delete cascade
        
) ENGINE = INNODB;

#insert di prova per testare la creazione di una sessione

INSERT INTO CONFERENZA (Acronimo, AnnoEdizione, ImgLogo, Nome,Svolgimento)
values ("Acronimo1",2022,"img1","Conferenza1","Attiva");
INSERT INTO CONFERENZA (Acronimo, AnnoEdizione, ImgLogo, Nome)
values ("Acronimo2",2022,"img1","Conferenza2");
INSERT INTO CONFERENZA (Acronimo, AnnoEdizione, ImgLogo, Nome)
values ("Acronimo3",2022,"img1","Conferenza3");

INSERT INTO CONFERENZA (Acronimo, AnnoEdizione, ImgLogo, Nome,Svolgimento)
values ("AcronimoEvento",2022,"img1","Conferenza1","Attiva");
 INSERT INTO PROGRAMMA_GIORNALIERO (Id, AcronimoConferenza, AnnoEdizioneConferenza, Data)
values ("010","AcronimoEvento",2022,"2022-08-12");

INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("CiccioSp", "123", "Ciccio", "Pasticcio", "Bologna", "2000-10-10");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("ZicP", "123", "Zic", "Allergy", "Bologna", "2000-10-10");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("ZurgP", "123", "Zurg", "Toy", "Bologna", "2000-10-10");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("ZurgSp", "123", "Zurg", "Toy", "Bologna", "2000-10-10");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("CarloAm", "abc", "Carlo", "Amato", "Bologna", "2000-01-20");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("Speaker1", "1234", "Sp", "eaker1", "Bologna", "2000-01-20");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("Speaker2", "12", "Sp", "eaker2", "Napoli", "2000-10-20");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("Presenter1", "126", "Pr", "es", "Napoli", "2000-10-20");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("Presenter2", "126", "Pr", "es", "Napoli", "2000-10-20");
INSERT INTO UTENTE (Username, Password, Nome, Cognome, LuogoNascita, DataNascita) 
values ("Aut", "0", "Pr", "es", "Napoli", "2000-10-20");


INSERT INTO PROGRAMMA_GIORNALIERO (Id, AcronimoConferenza, AnnoEdizioneConferenza, Data)
values ("007","Acronimo1",2022,"2022-08-12");
INSERT INTO PROGRAMMA_GIORNALIERO (Id, AcronimoConferenza, AnnoEdizioneConferenza, Data)
values ("008","Acronimo2",2022,"2022-08-15");
INSERT INTO PROGRAMMA_GIORNALIERO (Id, AcronimoConferenza, AnnoEdizioneConferenza, Data)
values ("009","Acronimo3",2022,"2022-08-15");

INSERT INTO SESSIONE (Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) 
values ("A123", "007", "link1", "11:00", "9:00", "titolo1");
INSERT INTO SESSIONE (Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) 
values ("A124", "008", "link1", "11:00", "9:00", "titolo1");
INSERT INTO SESSIONE (Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) 
values ("A125", "009", "link1", "11:00", "9:00", "titolo1");
INSERT INTO SESSIONE (Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) 
values ("A200", "007", "link2", "11:00", "9:00", "titolo2");
INSERT INTO SESSIONE (Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) 
values ("A1", "007", "link2", "11:00", "9:00", "titolo2");
INSERT INTO SESSIONE (Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) 
values ("A2", "007", "link2", "11:00", "9:00", "titolo2");
INSERT INTO SESSIONE (Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) 
values ("B1", "006", "link2", "11:00", "9:00", "titolo2");

INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("P125", "A123", 3, "11:00", "9:00"); 
INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("P126", "A123", 3, "11:00", "9:00"); 
INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("P127", "A124", 3, "11:00", "9:00"); 
INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("P1", "A1", 3, "11:00", "9:00"); 
INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("P2", "A2", 3, "11:00", "9:00"); 
INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("A1", "B1", 3, "11:00", "9:00");
INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("A2", "B1", 3, "11:00", "9:00"); 
INSERT INTO PRESENTAZIONE (Codice, CodiceSessione, NumSequenza, OraFine, OraIni) 
values ("A3", "B1", 3, "11:00", "9:00"); 

INSERT INTO PRESENTER (UsernameUtente, NomeUni, NomeDip, CV, Foto)
values ("ZicP", "Unibo", "InfoMan", "CV1", "Foto1");
INSERT INTO PRESENTER (UsernameUtente, NomeUni, NomeDip, CV, Foto)
values ("ZurgP", "Unibo", "InfoMan", "CV2", "Foto2");
INSERT INTO PRESENTER (UsernameUtente, NomeUni, NomeDip, CV, Foto)
values ("Presenter1", "RomaUNI", "InfoMan", "CV2", "Foto2");
INSERT INTO PRESENTER (UsernameUtente, NomeUni, NomeDip, CV, Foto)
values ("Presenter2", "Unibo", "InfoMan", "CV2", "Foto2");

INSERT INTO ARTICOLO (CodicePresentazione, CodiceSessionePresentazione, NumPagine, filePDF, Titolo, UsernamePresenter)
values ("P125", "A123", 20, "file.pdf", "Titolo1", "ZicP");
INSERT INTO ARTICOLO (CodicePresentazione, CodiceSessionePresentazione, NumPagine, filePDF, Titolo, UsernamePresenter)
values ("P127", "A124", 20, "file.pdf", "Titolo1", "ZurgP");
INSERT INTO ARTICOLO (CodicePresentazione, CodiceSessionePresentazione, NumPagine, filePDF, Titolo, UsernamePresenter)
values ("A1", "B1", 10, "file.pdf", "Titolo1", "Presenter1");
INSERT INTO ARTICOLO (CodicePresentazione, CodiceSessionePresentazione, NumPagine, filePDF, Titolo, UsernamePresenter)
values ("A2", "B1", 10, "file.pdf", "Titolo1", "Presenter1");
INSERT INTO ARTICOLO (CodicePresentazione, CodiceSessionePresentazione, NumPagine, filePDF, Titolo, UsernamePresenter)
values ("A3", "B1", 10, "file.pdf", "Titolo1", "Presenter2");


INSERT INTO AMMINISTRATORE (UsernameUtente)
values ("CiccioSp");

INSERT INTO AMMINISTRATORE (UsernameUtente)
values ("CarloAm");

INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CiccioSp", "P125", "A123", 7, "note");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CarloAm", "P125", "A123", 5, "note");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CiccioSp", "P127", "A124", 9, "note");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CiccioSp", "P1", "A1", 7, "buono");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CiccioSp", "A1", "B1", 6, "note");

INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CarloAm", "P1", "A1", 9, "nice");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CarloAm", "P2", "A2", 6, "mmmmh");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CarloAm", "A1", "B1", 4, "note");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CarloAm", "A2", "B1", 7, "note");
INSERT INTO VALUTAZIONE (UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione, Voto, Note)
values ("CarloAm", "A3", "B1", 6, "note");



-- INSERT INTO SPEAKER (UsernameUtente, NomeUni, NomeDip, CV, Foto) 
-- values ("CiccioSp", "Unibo", "Informatica", "Sono bravo a esporre", "imgCiccio");
INSERT INTO SPEAKER (UsernameUtente, NomeUni, NomeDip, CV, Foto) 
values ("Speaker1", "Unibo", "Informatica", "Sono bravo", "bldla");
INSERT INTO SPEAKER (UsernameUtente, NomeUni, NomeDip, CV, Foto) 
values ("Speaker2", "Unibo", "Mate", "Sono calvo", "xnreo");


INSERT INTO TUTORIAL (CodicePresentazione, CodiceSessionePresentazione, Titolo, Abstract) 
values ("P125", "A123", "Come fare schifo", "hwqvouq");

INSERT INTO TUTORIAL (CodicePresentazione, CodiceSessionePresentazione, Titolo, Abstract) 
values ("P1", "A1", "Come fare schifo", "hwqvouq");
INSERT INTO TUTORIAL (CodicePresentazione, CodiceSessionePresentazione, Titolo, Abstract) 
values ("P2", "A2", "Come fare la pasta", "ccca");

-- INSERT INTO presentazione_tutorial (UsernameSpeaker,CodiceTutorial,CodiceSessioneTutorial) 
-- values ("CiccioSp","P125","A123");

INSERT INTO presentazione_tutorial (UsernameSpeaker,CodiceTutorial,CodiceSessioneTutorial) 
values ("Speaker1","P1","A1");
INSERT INTO presentazione_tutorial (UsernameSpeaker,CodiceTutorial,CodiceSessioneTutorial) 
values ("Speaker1","P2","A2");
INSERT INTO presentazione_tutorial (UsernameSpeaker,CodiceTutorial,CodiceSessioneTutorial) 
values ("Speaker2","P2","A2");

INSERT INTO programma_giornaliero(Id,AcronimoConferenza,AnnoEdizioneConferenza,Data)
VALUES ("001","Acronimo5","2022","2022-08-12");

-- INSERT INTO ARTICOLO(CodicePresentazione,CodiceSessionePresentazione,Numpagine,filePDF,Titolo,StatoSvolgimento,UsernamePresenter) 
-- values ("P128","A125",150,"meme1","Essere o non essere?","NonCoperto",null);

-- UPDATE ARTICOLO SET UsernamePresenter='CiccioSp' WHERE CodicePresentazione='P128';

-- INSERT INTO INFO_AGGIUNTIVE (UsernameSpeaker, CodiceTutorial, CodiceSessioneTutorial, LinkWeb, Descrizione) 
-- values ("CiccioSp", "P125", "A123", "link1", "descrizione1");



#Lista stored procedure
/********************************************************************************************************************************/
#Stored procedure 1 --> crea Conferenza
start transaction;
delimiter |
CREATE PROCEDURE CreaConferenza(IN Acronimo varchar(30), IN AnnoEdizione YEAR, IN ImgLogo BLOB, IN Nome varchar(30))
	BEGIN
			INSERT INTO CONFERENZA SET Acronimo = Acronimo, AnnoEdizione = AnnoEdizione, ImgLogo = ImgLogo, Nome = Nome;
	END;
| delimiter ;
commit;

#Stored procedure --> associa admin a conferenza creata
start transaction;
delimiter |
CREATE PROCEDURE AssociaAmministratore(UsernameAmministratore varchar(30), AcronimoConferenza varchar(30), AnnoEdizioneConferenza YEAR)
	BEGIN
			INSERT INTO CREAZIONE SET UsernameAmministratore = UsernameAmministratore, AcronimoConferenza = AcronimoConferenza, AnnoEdizioneConferenza = AnnoEdizioneConferenza;
	END;
| delimiter ;
commit;

#Stored procedure 2 --> crea programma_giornaliero
start transaction;
 delimiter |
 CREATE PROCEDURE CreaProgrammaGiornaliero(Id varchar(10), AcronimoConferenza varchar(30), AnnoEdizioneConferenza varchar(30), Data date)
	BEGIN
    INSERT INTO PROGRAMMA_GIORNALIERO SET  Id = Id, AcronimoConferenza = AcronimoConferenza, AnnoEdizioneConferenza = AnnoEdizioneConferenza;
    COMMIT;
    END
| delimiter ;

#Stored procedure 3 --> crea Sessione
start transaction;
delimiter |
CREATE PROCEDURE CreaSessione(IN Codice varchar(10), IN IdProgramma varchar(10),  IN LinkTeams varchar(100), IN OraIni time, IN OraFine time, IN Titolo varchar(100))
	begin
	#Controlla che esista un id uguale nella tabella PROGRAMMA_GIORNALIERO
	#Controlla che OraIni sia < di OraFine
		IF(OraIni < OraFine &&(SELECT count(PROGRAMMA_GIORNALIERO.Id) 
								 FROM PROGRAMMA_GIORNALIERO 
								WHERE PROGRAMMA_GIORNALIERO.Id = IdProgramma) > 0)
		THEN
			INSERT INTO SESSIONE 
			SET Codice = Codice, IdProgramma = IdProgramma, LinkTeams = LinkTeams, OraIni = OraIni, OraFine = OraFine, Titolo = Titolo;
			COMMIT;
		ELSE ROLLBACK;
		END IF;
	END;
| delimiter ;

#Stored procedure 4 --> crea Presentazione
start transaction;
delimiter |
CREATE PROCEDURE CreaPresentazione(Codice varchar(10), CodiceSessione varchar(10), NumSequenza int, OraFine time, OraIni time)
	begin
		#controlla che il codice sessione esista nella tabella Sessione
		IF((SELECT count(SESSIONE.Codice) 
			  FROM SESSIONE 
			 WHERE (SESSIONE.Codice = CodiceSessione) 
					AND (OraFine <= SESSIONE.OraFine) 
					AND (OraIni >= SESSIONE.OraIni)) > 0 && OraIni < OraFine)
		THEN
			INSERT INTO PRESENTAZIONE 
            SET Codice = Codice, CodiceSessione = CodiceSessione, NumSequenza = NumSequenza, OraFine = OraFine, OraIni = OraIni;
			COMMIT;
		ELSE ROLLBACK;
		END IF;
	END;
| delimiter ;

 # Stored procedure 5 --> associa speaker - tutorial
 start transaction;
delimiter |
CREATE PROCEDURE AssociaSpeaker(UsernameSpeaker varchar(30), CodiceTutorial varchar(10), CodiceSessioneTutorial varchar(10))
	BEGIN
		#Ci vuole il controllo se esiste gia l'associazione??
        #ci vuole il controllo per vedere se esiste quello speaker tra gli utenti
		if(SELECT count(SPEAKER.UsernameUtente) FROM SPEAKER WHERE SPEAKER.UsernameUtente = UsernameSpeaker) > 0 THEN
        INSERT INTO PRESENTAZIONE_TUTORIAL
        SET UsernameSpeaker = UsernameSpeaker, CodiceTutorial = CodiceTutorial, CodiceSessioneTutorial = CodiceSessioneTutorial;
        COMMIT;
        end if;
    END
 | delimiter ;
 /********************************************************************************************************************************/
 #Stored procedure 6 --> Associa un presenter alla presentazione di un articolo
-- start transaction;
-- delimiter |
-- CREATE PROCEDURE AssociaPresenter(CodicePresentazione varchar(10),CodiceSessionePresentazione varchar(10),UsernamePresenter varchar(30))
-- BEGIN
-- if((SELECT count(ARTICOLO.CodicePresentazione) FROM ARTICOLO WHERE 
-- ((ARTICOLO.CodicePresentazione=CodicePresentazione) and (ARTICOLO.CodiceSessionePresentazione=CodiceSessionePresentazione)))>0 AND 
-- (SELECT count(PRESENTER.UsernameUtente) FROM PRESENTER WHERE (PRESENTER.UsernameUtente=UsernamePresenter))>0 ) THEN
-- UPDATE ARTICOLO
-- SET 
-- UsernamePresenter=UsernamePresenter
-- WHERE
-- CodicePresentazione=CodicePresentazione AND CodiceSessionePresentazione=CodiceSessionePresentazione;
-- COMMIT;
-- end if;
-- END  
-- |delimiter;
 
 # Stored procedure 7 --> crea Utente, utile per la registrazione di un nuovo utente
 start transaction;
 delimiter |
 CREATE PROCEDURE CreaUtente(Username varchar(30), Password varchar(30), Nome varchar(30), Cognome varchar(30), LuogoNascita varchar(30), DataNascita Date)
	BEGIN
    INSERT INTO UTENTE SET  Username = Username, Password = Password, Nome = Nome, Cognome = Cognome, LuogoNascita = LuogoNascita, DataNascita = DataNascita;
    COMMIT;
    END
| delimiter ;

# Stored procedure 8 --> crea Speaker
 start transaction;
 delimiter |
 CREATE PROCEDURE CreaSpeaker(UsernameUtente varchar(30), NomeUni varchar(30), NomeDip varchar(30), CV varchar(30), Foto BLOB)
	BEGIN
    if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    INSERT INTO SPEAKER SET  UsernameUtente = UsernameUtente, NomeUni = NomeUni, NomeDip = NomeDip, CV = CV, Foto = Foto;
    COMMIT;
    end if;
    END
| delimiter ;

# Stored procedure 9 --> crea Presenter
 start transaction;
 delimiter |
 CREATE PROCEDURE CreaPresenter(UsernameUtente varchar(30), NomeUni varchar(30), NomeDip varchar(30), CV varchar(30), Foto BLOB)
	BEGIN
    if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    INSERT INTO PRESENTER SET  UsernameUtente = UsernameUtente, NomeUni = NomeUni, NomeDip = NomeDip, CV = CV, Foto = Foto;
    COMMIT;
    end if;
    END
| delimiter ;

# Stored procedure 10 --> modifica CV da parte dello speaker
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaCVSpeaker(UsernameUtente varchar(30), CV varchar(30))
	BEGIN
    #if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    UPDATE SPEAKER 
    SET CV = CV
    WHERE (SPEAKER.UsernameUtente = UsernameUtente);
    COMMIT;
    #end if;
    END
| delimiter ;

# Stored procedure 11 --> modifica Foto da parte dello speaker
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaFotoSpeaker(UsernameUtente varchar(30), Foto BLOB)
	BEGIN
    #if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    UPDATE SPEAKER 
    SET Foto = Foto
    WHERE (SPEAKER.UsernameUtente = UsernameUtente);
    COMMIT;
    #end if;
    END
| delimiter ;

# Stored procedure 12 --> modifica affiliazione universitaria da parte dello speaker
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaAffiliazioneSpeaker(UsernameUtente varchar(30), NomeUni varchar(30), NomeDip varchar(30))
	BEGIN
    #if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    UPDATE SPEAKER 
    SET NomeUni = NomeUni, NomeDip = NomeDip
    WHERE (SPEAKER.UsernameUtente = UsernameUtente);
    COMMIT;
    #end if;
    END
| delimiter ;

# Stored procedure 13 --> modifica CV da parte del presenter
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaCVPresenter(UsernameUtente varchar(30), CV varchar(30))
	BEGIN
    #if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    UPDATE PRESENTER 
    SET CV = CV
    WHERE (PRESENTER.UsernameUtente = UsernameUtente);
    COMMIT;
    #end if;
    END
| delimiter ;

# Stored procedure 14 --> modifica Foto da parte del presenter
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaFotoPresenter(UsernameUtente varchar(30), Foto BLOB)
	BEGIN
    #if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    UPDATE PRESENTER 
    SET Foto = Foto
    WHERE (PRESENTER.UsernameUtente = UsernameUtente);
    COMMIT;
    #end if;
    END
| delimiter ;

# Stored procedure 15 --> modifica affiliazione universitaria da parte del presenter
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaAffiliazionePresenter(UsernameUtente varchar(30), NomeUni varchar(30), NomeDip varchar(30))
	BEGIN
    #if(SELECT count(UTENTE.Username) FROM UTENTE WHERE UTENTE.Username = UsernameUtente) > 0 THEN
    UPDATE PRESENTER 
    SET NomeUni = NomeUni, NomeDip = NomeDip
    WHERE (PRESENTER.UsernameUtente = UsernameUtente);
    COMMIT;
    #end if;
    END
| delimiter ;

# Stored procedure 16 --> creazione di un tutorial
 start transaction;
 delimiter |
 CREATE PROCEDURE CreaTutorial(CodicePresentazione varchar(10), CodiceSessionePresentazione varchar(10), Titolo varchar(100), Abstract varchar(500))
	BEGIN
    INSERT INTO TUTORIAL 
    SET CodicePresentazione = CodicePresentazione, CodiceSessionePresentazione = CodiceSessionePresentazione, Titolo = Titolo, Abstract = Abstract;
    COMMIT;
    END
| delimiter ;

# Stored procedure 17 --> crea info aggiuntive
 start transaction;
 delimiter |
 CREATE PROCEDURE CreaInfoAggiuntive(UsernameSpeaker varchar(30), CodiceTutorial varchar(10), CodiceSessioneTutorial varchar(10), LinkWeb varchar(100), Descrizione varchar(500))
	BEGIN
    INSERT INTO INFO_AGGIUNTIVE 
    SET UsernameSpeaker = UsernameSpeaker, CodiceTutorial = CodiceTutorial, CodiceSessioneTutorial = CodiceSessioneTutorial, LinkWeb = LinkWeb, Descrizione = Descrizione;
    COMMIT;
    END
| delimiter ;

# Stored procedure 18 --> inserisci o modifica il link in info_aggiuntive
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaLinkInfoAggiuntive(UsernameSpeaker varchar(30), CodiceTutorial varchar(10), CodiceSessioneTutorial varchar(10), LinkWeb varchar(100))
	BEGIN
    UPDATE INFO_AGGIUNTIVE 
    SET LinkWeb = LinkWeb
    WHERE (INFO_AGGIUNTIVE.UsernameSpeaker = UsernameSpeaker) AND (INFO_AGGIUNTIVE.CodiceTutorial = CodiceTutorial) AND (INFO_AGGIUNTIVE.CodiceSessioneTutorial = CodiceSessioneTutorial);
    COMMIT;
    END
| delimiter ;

# Stored procedure 19 --> inserisci o modifica la descrizione in info_aggiuntive
 start transaction;
 delimiter |
 CREATE PROCEDURE ModificaDescrizioneInfoAggiuntive(UsernameSpeaker varchar(30), CodiceTutorial varchar(10), CodiceSessioneTutorial varchar(10), Descrizione varchar(500))
	BEGIN
    UPDATE INFO_AGGIUNTIVE 
    SET Descrizione = Descrizione
    WHERE (INFO_AGGIUNTIVE.UsernameSpeaker = UsernameSpeaker) AND (INFO_AGGIUNTIVE.CodiceTutorial = CodiceTutorial) AND (INFO_AGGIUNTIVE.CodiceSessioneTutorial = CodiceSessioneTutorial);
    COMMIT;
    END
| delimiter ;

# Stored procedure 20 --> registrazione a una conferenza
 start transaction;
 delimiter |
 CREATE PROCEDURE RegistrazioneConferenza(UsernameUtente varchar(30), AcronimoConferenza varchar(30), AnnoEdizioneConferenza YEAR)
	BEGIN
    INSERT INTO REGISTRAZIONE 
    SET UsernameUtente = UsernameUtente, AcronimoConferenza = AcronimoConferenza, AnnoEdizioneConferenza = AnnoEdizioneConferenza;
    COMMIT;
    END
| delimiter ;
#Store Procedure 21 --> Crea Articolo
start transaction;
delimiter |
CREATE PROCEDURE CreaArticolo(CodicePresentazione varchar(10),CodiceSessionePresentazione varchar(10),
 Numpagine int(11), filePDF blob, Titolo varchar(100),StatoSvolgimento enum('Coperto','NonCoperto'),UsernamePresenter varchar(30))
 BEGIN
 if(SELECT count(CodicePresentazione) FROM PRESENTAZIONE WHERE ((CodicePresentazione=CodicePresentazione) 
and (CodiceSessionePresentazione=CodiceSessionePresentazione))>0) then
INSERT INTO ARTICOLO
 SET CodicePresentazione=CodicePresentazione,
	CodiceSessionePresentazione=CodiceSessionePresentazione,
    Numpagine=Numpagine,
    filePDF=filePDF,
    Titolo=Titolo,
    StatoSvolgimento=StatoSvolgimento,
    UsernamePresenter=UsernamePresenter;
    COMMIT;
end if;
 END
| delimiter;
# Stored procedure 22 --> inserimento lista presentazioni favorite
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciPresentazionePreferitaInLista(UsernameUtente varchar(30), CodicePresentazione varchar(10), CodiceSessionePresentazione varchar(10))
	BEGIN
    INSERT INTO LISTA_PRESENTAZIONI_FAVORITE 
    SET UsernameUtente = UsernameUtente, CodicePresentazione = CodicePresentazione, CodiceSessionePresentazione = CodiceSessionePresentazione;
    COMMIT;
    END
| delimiter ;

# Stored procedure 23 --> inserimento sponsor
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciSponsor(Nome varchar(30), ImgLogo BLOB)
	BEGIN
    INSERT INTO SPONSOR
    SET Nome = Nome, ImgLogo = ImgLogo;
    COMMIT;
    END
| delimiter ;

# Stored procedure 24 --> inserimento sponsorizzazione
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciSponsorizzazione(NomeSponsor varchar(30), AcronimoConferenza varchar(30), AnnoEdizioneConferenza YEAR, Importo float)
	BEGIN
    INSERT INTO SPONSORIZZAZIONE
    SET NomeSponsor = NomeSponsor, AcronimoConferenza = AcronimoConferenza, AnnoEdizioneConferenza = AnnoEdizioneConferenza, Importo = Importo;
    COMMIT;
    END
| delimiter ;

# Stored procedure 25 --> inserisci autore
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciAutore(ID int, Nome varchar(30), Cognome varchar(30), CodiceArticolo varchar(10), CodiceSessioneArticolo varchar(10))
	BEGIN
    INSERT INTO AUTORE
    SET ID = ID, Nome = Nome, Cognome = Cognome;
    INSERT INTO LISTA_AUTORI
    SET IdAutore = ID, CodiceArticolo = CodiceArticolo, CodiceSessioneArticolo = CodiceSessioneArticolo;
    COMMIT;
    END
| delimiter ;


# Stored procedure 26 --> inserisci autore nella lista
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciListaAutori(IdAutore int, CodiceArticolo varchar(10), CodiceSessioneArticolo varchar(10))
	BEGIN
    INSERT INTO LISTA_AUTORI
    SET IdAutore = IdAutore, CodiceArticolo = CodiceArticolo, CodiceSessioneArticolo = CodiceSessioneArticolo;
    COMMIT;
    END
| delimiter ;

# Stored procedure 27 --> inserimento admin
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciAmministratore(UsernameUtente varchar(30))
	BEGIN
    INSERT INTO AMMINISTRATORE
    SET UsernameUtente = UsernameUtente;
    COMMIT;
    END
| delimiter ;

# Stored procedure 28 --> inserimento messaggio
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciMessaggio(CodiceSessione varchar(10), Timestamp float, UsernameUtente varchar(30), Testo varchar(500), DataInserimento date)
	BEGIN
    INSERT INTO MESSAGGIO
    SET CodiceSessione = CodiceSessione, Timestamp = Timestamp, UsernameUtente = UsernameUtente, Testo = Testo, DataInserimento = DataInserimento;
    COMMIT;
    END
| delimiter ;

# Stored procedure 29 --> inserimento valutazione
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciValutazione(UsernameAmministratore varchar(30), CodicePresentazione varchar(10), CodiceSessionePresentazione varchar(10), Voto int, Note varchar(50))
	BEGIN
    INSERT INTO VALUTAZIONE
    SET UsernameAmministratore = UsernameAmministratore, CodicePresentazione = CodicePresentazione, CodiceSessionePresentazione = CodiceSessionePresentazione, Voto = Voto, Note = Note;
    COMMIT;
    END
| delimiter ;

# Stored procedure 30 --> inserimento parola chiave
 start transaction;
 delimiter |
 CREATE PROCEDURE InserisciParolaChiave(CodiceArticolo varchar(10), Parola varchar(20))
	BEGIN
    INSERT INTO PAROLA_CHIAVE
    SET CodiceArticolo = CodiceArticolo, Parola = Parola;
    COMMIT;
    END
| delimiter ;

# Stored procedure 31 --> elimina conferenza
 start transaction;
 delimiter |
 CREATE PROCEDURE EliminaConferenza(Acronimo varchar(30), AnnoEdizione YEAR)
	BEGIN
    DELETE FROM CONFERENZA
	WHERE (CONFERENZA.Acronimo = Acronimo) AND (CONFERENZA.AnnoEdizione = AnnoEdizione);
    COMMIT;
    END
| delimiter ;

# Stored procedure 32 --> elimina sessione
 start transaction;
 delimiter |
 CREATE PROCEDURE EliminaSessione(Codice varchar(10))
	BEGIN
    DELETE FROM SESSIONE
	WHERE (SESSIONE.Codice = Codice);
    COMMIT;
    END
| delimiter ;

# Stored procedure 33 --> elimina presentazione
 start transaction;
 delimiter |
 CREATE PROCEDURE EliminaPresentazione(Codice varchar(10), CodiceSessione varchar(10))
	BEGIN
    DELETE FROM PRESENTAZIONE
	WHERE (PRESENTAZIONE.Codice = Codice) AND (PRESENTAZIONE.CodiceSessione = CodiceSessione);
    COMMIT;
    END
| delimiter ;

# Stored procedure 34 --> elimina info aggiuntive
 start transaction;
 delimiter |
 CREATE PROCEDURE EliminaInfoAggiuntive(UsernameSpeaker varchar(30), CodiceTutorial varchar(10), CodiceSessioneTutorial varchar(10))
	BEGIN
    DELETE FROM INFO_AGGIUNTIVE
	WHERE (INFO_AGGIUNTIVE.UsernameSpeaker = UsernameSpeaker) AND (INFO_AGGIUNTIVE.CodiceTutorial = CodiceTutorial) AND (INFO_AGGIUNTIVE.CodiceSessioneTutorial = CodiceSessioneTutorial);
    COMMIT;
    END
| delimiter ;
/********************************************************************************************************************************/
 

 
 #Lista dei trigger
/********************************************************************************************************************************/
#Trigger 1 --> Aggiorna il numero di presentazioni dentro la tabella SESSIONE
delimiter |
CREATE TRIGGER AggiornaNumeroPresentazioni
		 AFTER INSERT ON PRESENTAZIONE
  FOR EACH ROW
		 BEGIN
				UPDATE SESSIONE
				   SET SESSIONE.NumPresentazioni =  SESSIONE.NumPresentazioni + 1
				 WHERE SESSIONE.Codice = NEW.CodiceSessione;
		   END;
| delimiter ;
/********************************************************************************************************************************/ 


DROP TRIGGER IF EXISTS CambiaStatoSvolgimento;
# trigger 2 : setta stato svolgimento a "Coperto" quando viene associato un Presenter ad un Articolo
delimiter |
CREATE TRIGGER CambiaStatoSvolgimento BEFORE INSERT ON ARTICOLO
  FOR EACH ROW
  BEGIN
				 #UPDATE ARTICOLO
				   SET NEW.StatoSvolgimento = "Coperto";
				 #WHERE UsernamePresenter is not null;
  END
| delimiter ;


#Lista delle view
/********************************************************************************************************************************/ 
#View 1 | che restituisce le conferenze disponibili
delimiter |
CREATE VIEW CONFERENZE_DISPONIBILI(Acronimo, Nome, ImgLogo, AnnoEdizione) AS
	 SELECT Acronimo, Nome, ImgLogo, AnnoEdizione
	   FROM CONFERENZA
	  WHERE (Svolgimento = "Attiva")
| delimiter ;

#View 2 | che restituisce il numero totale delle conferenze attive
delimiter |
CREATE VIEW ConferenzeAttive(TotConferenzeAttive) AS
	 SELECT count(*)
	 FROM CONFERENZA
     WHERE (Svolgimento = "Attiva")
| delimiter ;

#View 3 |  che restituisce il numero totale degli utenti registrati
delimiter |
CREATE VIEW UtentiRegistrati(TotUtenti) AS
	 SELECT count(*)
	 FROM UTENTE
| delimiter ;

#View 4 | che restituisce tutte le sessioni presenti
delimiter |
CREATE VIEW SessioniPresenti(Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo) AS
	 SELECT Codice, IdProgramma, LinkTeams, OraFine, OraIni, Titolo
	 FROM SESSIONE
| delimiter ;

#View 5 | che restituisce il numero tot delle conferenze registrate (in tutta la piattaforma)
delimiter |
CREATE VIEW NumConferenzeRegistrate(TotConferenze) AS
	 SELECT count(*)
	 FROM CONFERENZA
| delimiter ;

# TESTARE
#View -> che restituisce lista presenters in base al voto medio in modo discendente
# Se volessimo vedere nella classifica anche i presenter che non hanno nessun voto associato??????????????????????????????????????????????????????????
-- delimiter |
-- CREATE VIEW PresenterVotoMed(UsernamePresenter, VotoMed,Tipo) AS
-- 	 SELECT PRESENTER.UsernameUtente, AVG(VALUTAZIONE.Voto) AS VotoMed,
--       CASE WHEN UsernameUtente is not null THEN "Presenter" END AS TipoUtente
-- 	 FROM PRESENTER, VALUTAZIONE, ARTICOLO
--      WHERE (PRESENTER.UsernameUtente = ARTICOLO.UsernamePresenter) AND
-- 		   (ARTICOLO.CodicePresentazione = VALUTAZIONE.CodicePresentazione) AND
--            (ARTICOLO.CodiceSessionePresentazione = VALUTAZIONE.CodiceSessionePresentazione) # AND
--            #(ARTICOLO.UsernamePresenter = PRESENTER.UsernameUtente) vedi se serve doppio controllo o no
-- 	GROUP BY PRESENTER.UsernameUtente
--     ORDER BY VotoMed DESC
-- | delimiter ;

#View -> che restituisce lista speaker in base al voto medio in modo discendente
# TO-DO
# Se volessimo vedere nella classifica anche gli speaker che non hanno nessun voto associato??????????????????????????????????????????????????????????
-- delimiter |
-- CREATE VIEW SpeakerVotoMed(UsernameSpeaker, VotoMed ,Tipo) AS
-- 	 SELECT SPEAKER.UsernameUtente, AVG(VALUTAZIONE.Voto) AS VotoMed,
--      CASE WHEN UsernameUtente is not null THEN "Speaker" END AS TipoUtente
-- 	 FROM SPEAKER, VALUTAZIONE, PRESENTAZIONE_TUTORIAL
--      WHERE (SPEAKER.UsernameUtente = PRESENTAZIONE_TUTORIAL.UsernameSpeaker) AND
-- 		   (PRESENTAZIONE_TUTORIAL.CodiceTutorial = VALUTAZIONE.CodicePresentazione) AND
--            (PRESENTAZIONE_TUTORIAL.CodiceSessioneTutorial = VALUTAZIONE.CodiceSessionePresentazione) #AND
--            #(PRESENTAZIONE_TUTORIAL.UsernameSpeaker = SPEAKER.UsernameUtente) vedi se serve doppio controllo o no
-- 	GROUP BY SPEAKER.UsernameUtente
--     ORDER BY VotoMed DESC
-- | delimiter ;


#View 6 | Visualizza i presenter/speaker sulla base del voto medio
delimiter |
CREATE VIEW presenter_speaker_votomedio(Username,VotoMed,Tipo) AS
	 SELECT Utente.Username, AVG(VALUTAZIONE.Voto) AS VotoMed,
     CASE WHEN Utente.Username=Speaker.UsernameUtente THEN "Speaker" 
     ELSE "Presenter" END as TipoUtente
     FROM Utente,Speaker,Presenter,Valutazione,presentazione_tutorial,Articolo
     WHERE ((Utente.Username=Speaker.UsernameUtente) AND (SPEAKER.UsernameUtente = PRESENTAZIONE_TUTORIAL.UsernameSpeaker) AND
		   (PRESENTAZIONE_TUTORIAL.CodiceTutorial = VALUTAZIONE.CodicePresentazione) AND
           (PRESENTAZIONE_TUTORIAL.CodiceSessioneTutorial = VALUTAZIONE.CodiceSessionePresentazione)) # Caso in cui è uno Speaker
           OR 
           ((Utente.Username=Presenter.UsernameUtente) AND (PRESENTER.UsernameUtente = ARTICOLO.UsernamePresenter) AND
		   (ARTICOLO.CodicePresentazione = VALUTAZIONE.CodicePresentazione) AND
           (ARTICOLO.CodiceSessionePresentazione = VALUTAZIONE.CodiceSessionePresentazione)) # Caso in cui è uno Presenter
           group by (Username)
		   ORDER BY VotoMed DESC;
           
           
| delimiter;
#View 7 |
delimiter |
CREATE VIEW VisualizzaSessioni (CodiceSessione,IdProgramma,LinkTeams,NumPresentazioni,OraFineSessione,OraIniSessione,Titolo) AS
SELECT Codice as CodiceSessione,IdProgramma,LinkTeams,NumPresentazioni,OraFine as OraFineSessione,OraIni as OraIniSessione,Titolo
FROM SESSIONE
| delimiter;
/********************************************************************************************************************************/ 
 delimiter |
 CREATE VIEW VisualizzaPresentazioni (CodicePresentazione,NumSequenza,CodiceSessionePr,OraFinePresentazione,OraIniPresentazione) AS
 SELECT Codice as CodicePresentazione,NumSequenza,CodiceSessione as CodiceSessionePr, OraFine as OraFinePresentazione, OraIni as OraIniPresentazione
 FROM PRESENTAZIONE
 | delimiter;
/********************************************************************************************************************************/ 
-- View 6 | Visualizzare le Sessioni e le presentazioni di ogni sessione
delimiter |
CREATE VIEW VisualizzaPresentazioniSessioni(CodiceSessione,IdProgramma,LinkTeams,NumPresentazioni,OraFineSessione,OraIniSessione,Titolo,CodicePresentazione,NumSequenza,OraFinePresentazione,OraIniPresentazione) AS
SELECT CodiceSessione,IdProgramma,LinkTeams,NumPresentazioni,OraFineSessione,OraIniSessione,Titolo,CodicePresentazione,NumSequenza,OraFinePresentazione,OraIniPresentazione
FROM VisualizzaPresentazioni,VisualizzaSessioni
WHERE CodiceSessione=CodiceSessionePr
GROUP BY (CodiceSessione)
| delimiter;
/********************************************************************************************************************************/ 

# evento 1: setta svolgimento della conferenza a "Completata" dopo la scadenza
delimiter |
CREATE EVENT ModificaSvolgimento
ON SCHEDULE EVERY 24 HOUR
DO
	UPDATE CONFERENZA, PROGRAMMA_GIORNALIERO
	   SET CONFERENZA.Svolgimento = "Completata"
       #PRIMA era >=, ma nella richiesta è che sia "passato un giorno" quindi solo >
	 WHERE now() > PROGRAMMA_GIORNALIERO.Data;
| delimiter ;