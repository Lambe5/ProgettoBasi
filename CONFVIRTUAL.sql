DROP DATABASE IF EXISTS CONFVIRTUAL;
CREATE DATABASE CONFVIRTUAL;
USE CONFVIRTUAL;

CREATE TABLE UTENTE(
				   Username varchar(30) primary key,
                   Password varchar(30),
                   Nome varchar(30),
                   Cognome varchar(30),
                   LuogoNascita varchar(30),
				   DataNascita Date);
 
 CREATE TABLE PRESENTER(
					   UsernameUtente varchar(30) primary key,
                       foreign key(UsernameUtente) references UTENTE(Username),
                       NomeUni varchar(30),
					   NomeDip varchar(30),
                       CV varchar(30),
                       Foto BLOB);
 
 CREATE TABLE SPEAKER(
					UsernameUtente varchar(30) primary key,
                    foreign key(UsernameUtente) references UTENTE(Username),
                    NomeUni varchar(30),
					NomeDip varchar(30),
                    CV varchar(30),
                    Foto BLOB);
 
 CREATE TABLE AMMINISTRATORE(
							UsernameUtente varchar(30) primary key,
                            foreign key(UsernameUtente) references UTENTE(Username));
 
 CREATE TABLE SPONSOR(
					 Nome varchar(30) primary key,
                     ImgLogo BLOB);
 
 CREATE TABLE CONFERENZA(
						Acronimo varchar(30),
                        AnnoEdizione YEAR,
                        ImgLogo BLOB,
                        Data date NOT NULL,
						Nome varchar(30) NOT NULL,
                        Svolgimento ENUM("Attiva", "Completata") DEFAULT "Attiva"
						/*primary key(Acronimo, AnnoEdizione)*/);
 
 CREATE TABLE SPONSORIZZAZIONE(
							  NomeSponsor varchar(30),
                              AcronimoConferenza varchar(30),
                              AnnoEdizioneConferenza YEAR,
                              Importo float NOT NULL, 
							  primary key(NomeSponsor, AcronimoConferenza, AnnoEdizioneConferenza),
                              foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione),
                              foreign key(NomeSponsor) references SPONSOR(Nome));
 
 CREATE TABLE PROGRAMMA_GIORNALIERO(
								   AcronimoConferenza varchar(30),
                                   Data date,
                                   primary key(AcronimoConferenza, Data), 
								   foreign key(AcronimoConferenza) references CONFERENZA(Acronimo));
 
 CREATE TABLE SESSIONE(
					  DataProgramma date NOT NULL references PROGRAMMA_GIORNALIERO(Data),
                      Codice varchar(10) primary key,
                      LinkTeams varchar(100),
					  Numpresentazioni int,
                      OraFine time,
                      OraIni time,
                      Titolo varchar(100)); 
 
 CREATE TABLE MESSAGGIO(
					   CodiceSessione varchar(10) references SESSIONE(Codice),
                       Timestamp float,
					   UsernameUtente varchar(30) NOT NULL references UTENTE(Username),
                       Testo varchar(500),
                       DataInserimento date, 
					   primary key (CodiceSessione, Timestamp));
 
 CREATE TABLE PRESENTAZIONE(
						   Codice varchar(10),
                           CodiceSessione varchar(10) references SESSIONE(Codice),
                           NumSequenza int,
                           OraFine time,
						   OraIni time,
                           primary key(Codice, CodiceSessione));
 
 CREATE TABLE ARTICOLO(
					  CodicePresentazione varchar(10) references PRESENTAZIONE(Codice),
					  CodiceSessionePresentazione varchar(10) references PRESENTAZIONE(CodiceSessione),
                      Numpagine int,
                      filePDF BLOB,
					  Titolo varchar(100),
                      StatoSvolgimento ENUM("Coperto", "NonCoperto") DEFAULT "Coperto",
					  UsernamePresenter varchar(30) references PRESENTER(UsernameUtete),
                      primary key(CodicePresentazione, CodiceSessionePresentazione));
 
 CREATE TABLE TUTORIAL(
					  CodicePresentazione varchar(10),
                      CodiceSessionePresentazione varchar(10),
                      Titolo varchar(100),
                      Abstract varchar(500), 
				      primary key(CodicePresentazione, CodiceSessionePresentazione),
				      foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione)); 
 
 CREATE TABLE AUTORE(
					ID int primary key,
                    Nome varchar(30) NOT NULL,
                    Cognome varchar(30) NOT NULL);
 
 CREATE TABLE LISTA_AUTORI(
						  IdAutore int,
                          CodiceArticolo varchar(10),
                          CodiceSessioneArticolo varchar(10), 
						  primary key(IdAutore, CodiceArticolo, CodiceSessioneArticolo), 
						  foreign key(CodiceArticolo, CodiceSessioneArticolo) references ARTICOLO(CodicePresentazione, CodiceSessionePresentazione), 
						  foreign key(IdAutore) references AUTORE(ID));
 
 CREATE TABLE PAROLA_CHIAVE(
						   CodiceArticolo varchar(10) primary key references ARTICOLO(Codice),
                           Parola varchar(20));
 
 CREATE TABLE LISTA_PRESENTAZIONI_FAVORITE(
										  UsernameUtente varchar(30) references UTENTE(Username),
                                          CodicePresentazione varchar(10),
										  CodiceSessionePresentazione varchar(10),
                                          primary key(UsernameUtente, CodicePresentazione, CodiceSessionePresentazione), 
									      foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione));
 
 CREATE TABLE REGISTRAZIONE(
						   UsernameUtente varchar(30) references UTENTE(Username),
                           AcronimoConferenza varchar(30),
						   AnnoEdizioneConferenza YEAR,
                           primary key(UsernameUtente, AcronimoConferenza, AnnoEdizioneConferenza), 
						   foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione));
 
 CREATE TABLE CREAZIONE(
					   UsernameAmministratore varchar(30) references AMMINISTRATORE(UsernameUtente),
                       AcronimoConferenza varchar(30),
					   AnnoEdizioneConferenza YEAR,
                       primary key(UsernameAmministratore, AcronimoConferenza, AnnoEdizioneConferenza), 
					   foreign key(AcronimoConferenza, AnnoEdizioneConferenza) references CONFERENZA(Acronimo, AnnoEdizione));
 
 CREATE TABLE VALUTAZIONE(
						 UsernameAmministratore varchar(30),
						 CodicePresentazione varchar(10),
                         CodiceSessionePresentazione varchar(10),
                         Voto int CHECK(Voto >= 0 and Voto <= 10),
                         Note varchar(50), 
						 primary key(UsernameAmministratore, CodicePresentazione, CodiceSessionePresentazione), 
						 foreign key(CodicePresentazione, CodiceSessionePresentazione) references PRESENTAZIONE(Codice, CodiceSessione), 
						 foreign key(UsernameAmministratore) references AMMINISTRATORE(UsernameUtente)); 
 
 CREATE TABLE INFO_AGGIUNTIVE(
							 UsernameSpeaker varchar(30) references SPEAKER(UsernameUtente),
                             CodiceTutorial varchar(10),
							 CodiceSessioneTutorial varchar(10),
                             LinkWeb varchar(100),
                             Descrizione varchar(500),
							 primary key(UsernameSpeaker, CodiceTutorial, CodiceSessioneTutorial), 
							 foreign key(CodiceTutorial, CodiceSessioneTutorial) references TUTORIAL(CodicePresentazione, CodiceSessionePresentazione));
 
CREATE TABLE PRESENTAZIONE_TUTORIAL(
								   UsernameSpeaker varchar(30) references SPEAKER(UsernameUtente),
                                   CodiceTutorial varchar(10),
								   CodiceSessioneTutorial varchar(10),
                                   primary key(UsernameSpeaker, CodiceTutorial, CodiceSessioneTutorial), 
								   foreign key(CodiceTutorial, CodiceSessioneTutorial) references TUTORIAL(CodicePresentazione, CodiceSessionePresentazione));
 
 
 
 
 
 