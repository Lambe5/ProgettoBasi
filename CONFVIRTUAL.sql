DROP DATABASE IF EXISTS CONFVIRTUAL;
CREATE DATABASE CONFVIRTUAL;
USE CONFVIRTUAL;

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
		
        foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione),
		foreign key(NomeSponsor) references SPONSOR(Nome)
        
) ENGINE = INNODB;
 
CREATE TABLE PROGRAMMA_GIORNALIERO(
		Id varchar(10), 
		AcronimoConferenza varchar(30) references CONFERENZA(Acronimo),
        AnnoEdizioneConferenza varchar(30) references CONFERENZA(AnnoEdizione),
		Data 			   date,
		
        primary key(Id)
		        
) ENGINE = INNODB;
 
CREATE TABLE SESSIONE(
		Codice 			 varchar(10)   primary key,
		IdProgramma 	 varchar(10) NOT NULL references PROGRAMMA_GIORNALIERO(Id),
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
        
        foreign key(CodiceSessione) references SESSIONE(Codice),
        foreign key(UsernameUtente) references UTENTE(Username)
        
) ENGINE = INNODB;
 
CREATE TABLE PRESENTAZIONE(
		Codice 		   varchar(10),
		CodiceSessione varchar(10),
		NumSequenza    int,
		OraFine 	   time,
		OraIni 		   time,
		
        primary key(Codice, CodiceSessione),
        
        foreign key(CodiceSessione) references SESSIONE(Codice)
        
) ENGINE = INNODB;
 
 CREATE TABLE ARTICOLO(
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		Numpagine 		    		int,
		filePDF 		    		BLOB,
		Titolo 			    		varchar(100),
		StatoSvolgimento    		ENUM("Coperto", "NonCoperto") DEFAULT "Coperto",
		UsernamePresenter   		varchar(30),
        
		primary key(CodicePresentazione, CodiceSessionePresentazione),
        
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione),
        foreign key(UsernamePresenter) references PRESENTER(UsernameUtente)
        
) ENGINE = INNODB;
 
CREATE TABLE TUTORIAL(
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		Titolo 						varchar(100),
		Abstract 					varchar(500), 
		
        primary key(CodicePresentazione, CodiceSessionePresentazione),
		
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione)
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
        
		foreign key(CodiceArticolo, CodiceSessioneArticolo) references ARTICOLO(CodicePresentazione, CodiceSessionePresentazione), 
		foreign key(IdAutore) references AUTORE(ID)
        
) ENGINE = INNODB;
 
CREATE TABLE PAROLA_CHIAVE(
		CodiceArticolo varchar(10) primary key references ARTICOLO(Codice),
		Parola 		   varchar(20)
        
) ENGINE = INNODB;
 
CREATE TABLE LISTA_PRESENTAZIONI_FAVORITE(
		UsernameUtente 				varchar(30),
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		
        primary key(UsernameUtente, CodicePresentazione, CodiceSessionePresentazione), 
		
        foreign key(UsernameUtente) references UTENTE(Username),
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione)
        
) ENGINE = INNODB;
 
CREATE TABLE REGISTRAZIONE(
		UsernameUtente 		   varchar(30),
		AcronimoConferenza 	   varchar(30),
		AnnoEdizioneConferenza YEAR,
		
        primary key(UsernameUtente, AcronimoConferenza, AnnoEdizioneConferenza), 
		
        foreign key(UsernameUtente) references UTENTE(Username),
        foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione)

) ENGINE = INNODB;

CREATE TABLE CREAZIONE(
		UsernameAmministratore varchar(30),
		AcronimoConferenza 	   varchar(30),
		AnnoEdizioneConferenza YEAR,
		
        primary key(UsernameAmministratore, AcronimoConferenza, AnnoEdizioneConferenza),
        
		foreign key(UsernameAmministratore) references AMMINISTRATORE(UsernameUtente),
        foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione)
        
) ENGINE = INNODB;
 
CREATE TABLE VALUTAZIONE(
		UsernameAmministratore 		varchar(30),
		CodicePresentazione 		varchar(10),
		CodiceSessionePresentazione varchar(10),
		Voto 						int 		CHECK(Voto >= 0 and Voto <= 10),
		Note 						varchar(50), 
		
        primary key(UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione), 
		
        foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione), 
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
		foreign key(CodiceTutorial, CodiceSessioneTutorial) references TUTORIAL(CodicePresentazione, CodiceSessionePresentazione)
        
) ENGINE = INNODB;
 
CREATE TABLE PRESENTAZIONE_TUTORIAL(
		UsernameSpeaker 		varchar(30),
		CodiceTutorial 			varchar(10),
		CodiceSessioneTutorial 	varchar(10),
		
        primary key(UsernameSpeaker, CodiceTutorial, CodiceSessioneTutorial),
        
		foreign key(UsernameSpeaker) references SPEAKER(UsernameUtente),
        foreign key(CodiceTutorial, CodiceSessioneTutorial) references TUTORIAL(CodicePresentazione, CodiceSessionePresentazione)
        
) ENGINE = INNODB;

#insert di prova per testare la creazione di una sessione
INSERT INTO CONFERENZA (Acronimo, AnnoEdizione, ImgLogo, Nome)
 values ("Acronimo1",2022,"img1","Conferenza1");
 
INSERT INTO PROGRAMMA_GIORNALIERO (Id, AcronimoConferenza, AnnoEdizioneConferenza, Data)
 values ("007","Acronimo1",2022,"2022-08-15");


#Lista stored procedure
/********************************************************************************************************************************/
#Stored procedure 1 --> crea Conferenza
start transaction;
delimiter |
CREATE PROCEDURE CreaConferenza(IN Acronimo varchar(30), IN AnnoEdizione YEAR, IN ImgLogo BLOB, IN Nome varchar(30))
begin
insert into CONFERENZA set Acronimo = Acronimo, AnnoEdizione = AnnoEdizione, ImgLogo = ImgLogo, Nome = Nome;
end;
| delimiter ;
commit;

#Stored procedure 2 --> crea Sessione
start transaction;
delimiter |
CREATE PROCEDURE CreaSessione(IN Codice varchar(10), IN IdProgramma varchar(10),  IN LinkTeams varchar(100), IN OraIni time, IN OraFine time, IN Titolo varchar(100))
begin
#Controlla che esista un id uguale nella tabella PROGRAMMA_GIORNALIERO
#Controlla che OraIni sia < di OraFine
if(OraIni < OraFine
   &&(SELECT count(PROGRAMMA_GIORNALIERO.Id) FROM PROGRAMMA_GIORNALIERO WHERE PROGRAMMA_GIORNALIERO.Id = IdProgramma) > 0) then
insert into SESSIONE set Codice = Codice, IdProgramma = IdProgramma, LinkTeams = LinkTeams, OraIni = OraIni, OraFine = OraFine, Titolo = Titolo;
commit;
else rollback;
end if;
end;
| delimiter ;

#Stored procedure 3 --> crea Presentazione
start transaction;
delimiter |
CREATE PROCEDURE CreaPresentazione(Codice varchar(10), CodiceSessione varchar(10), NumSequenza int, OraFine time, OraIni time)
begin
#controlla che il codice sessione esista nella tabella Sessione
if((SELECT count(SESSIONE.Codice) FROM SESSIONE WHERE (SESSIONE.Codice = CodiceSessione) AND (OraFine <= SESSIONE.OraFine) AND (OraIni >= SESSIONE.OraIni)) > 0
	&& OraIni < OraFine) then
    insert into PRESENTAZIONE set Codice = Codice, CodiceSessione = CodiceSessione, NumSequenza = NumSequenza, OraFine = OraFine, OraIni = OraIni;
commit;
else rollback;
end if;
end;
| delimiter ;
/********************************************************************************************************************************/
 
 
 #Lista dei trigger
/********************************************************************************************************************************/
#Trigger1 --> Aggiorna il numero di presentazioni dentro la tabella SESSIONE
delimiter |
CREATE TRIGGER AggiornaNumeroPresentazioni
after insert on PRESENTAZIONE
for each row
begin
update SESSIONE
set SESSIONE.NumPresentazioni =  SESSIONE.NumPresentazioni + 1
where SESSIONE.Codice = NEW.CodiceSessione;
end;
| delimiter ;
/********************************************************************************************************************************/ 


#Lista delle view
/********************************************************************************************************************************/ 
delimiter |
CREATE VIEW CONFERENZE_DISPONIBILI(Acronimo, Nome, ImgLogo, AnnoEdizione)
AS SELECT Acronimo, Nome, ImgLogo, AnnoEdizione
FROM CONFERENZA
WHERE (Svolgimento = "Attiva")
| delimiter ;
/********************************************************************************************************************************/ 
 
 