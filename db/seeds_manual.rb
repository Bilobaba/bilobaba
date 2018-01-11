@user = Member.find_by(email: "marc.silvestre@ymail.com")

  @evt = Event.new; @evt.title = "VAGUES 5 RYTHMES "; @evt.description = "Cours de 5 rythmes"; @evt.begin = DateTime.new( 2018  ,  1  , 5  ,  19 ,  30 ); @evt.end = DateTime.new( 2018  ,  1  ,  5 ,  21 ,  30 ); @evt.price_max =   20 ; @evt.price_min = 15; @evt.adress = "15 rue Geoffroy l Asnier "; @evt.zip = "75004"; @evt.town = "Paris"; @evt.organizer = @user; @evt.save

@user = User.find_by(email: "goundor@orange.fr")

  @evt = Event.new; @evt.titre = "Danser la vague des 5 Rythmes"; @evt.description = "Cours de 5 rythmes"; @evt.debut = DateTime.new( 2016  ,  9  ,  11 ,  15 ,  0  ); @evt.fin = DateTime.new( 2016  ,  9  ,  11 ,  17 ,  0  ); @evt.prix =   18 ; @evt.lieu = "Studio One Step"; @evt.adresse = "18-20 rue du faubourg du Temple"; @evt.cp = "75011"; @evt.ville = "Paris"; @evt.pays = "France"; @evt.reduit = "15"; @evt.transport = "M° République"; @evt.contact = ""; @evt.user = @user; @evt.set_search; @evt.save

@user = User.find_by(email: "carinebourny.5r@gmail.com")

  @evt = Event.new; @evt.titre = "Danse des 5 rythmes"; @evt.description = "Cours de 5 rythmes"; @evt.debut = DateTime.new( 2016  ,  9  ,  24 ,  18 ,  30 ); @evt.fin = DateTime.new( 2016  ,  9  ,  24 ,  20 ,  30 ); @evt.prix =   20; @evt.lieu = "Studio Bleu"; @evt.adresse = "14, boulevard Poissonnière"; @evt.cp = "75009"; @evt.ville = "Paris"; @evt.pays = "France"; @evt.reduit = "15 € - 12 €"; @evt.transport = "M° Grands Boulevards "; @evt.contact = ""; @evt.user = @user; @evt.set_search; @evt.save

@user = Member.find_by(email: "justdancewithlife.uk@gmail.com")

  @evt = Event.new; @evt.titre = "La Fièvre du Vendredi soir !"; @evt.description = "Movement medecine"; @evt.debut = DateTime.new( 2016  ,  9  ,  16 ,  19 ,  30 ); @evt.fin = DateTime.new( 2016  ,  9  ,  16 ,  21 ,  30 ); @evt.prix =   16 ; @evt.lieu = "Studio One Step"; @evt.adresse = "18, rue Fb du Temple "; @evt.cp = "75011"; @evt.ville = "Paris"; @evt.pays = "France"; @evt.reduit = "14 € - 12 €"; @evt.transport = "M° République - sortie 4"; @evt.contact = ""; @evt.user = @user; @evt.set_search; @evt.save

@user = User.find_by(email: "garancem@msn.com")

  @evt = Event.new; @evt.titre = "Atelier Openfloor"; @evt.description = "Openfloor"; @evt.debut = DateTime.new( 2016  ,  9  ,  25 ,  11 ,  0  ); @evt.fin = DateTime.new( 2016  ,  9  ,  25 ,  13 ,  0  ); @evt.prix =   20 ; @evt.lieu = "Salle Alter Active"; @evt.adresse = "20, chemin des Prés "; @evt.cp = "77810"; @evt.ville = "Thomery"; @evt.pays = "France"; @evt.reduit = "15"; @evt.transport = "Gare de Champagne sur Seine"; @evt.contact = ""; @evt.user = @user; @evt.set_search; @evt.save

@user = User.find_by(email: "merlinlise@gmail.com")

  @evt = Event.new; @evt.titre = "Bouger, Se Libérer, Se Transformer"; @evt.description = "Cours de 5 rythmes"; @evt.debut = DateTime.new( 2016  ,  9  ,  14 ,  19 ,  30 ); @evt.fin = DateTime.new( 2016  ,  9  ,  14 ,  21 ,  30 ); @evt.prix =   20 ; @evt.lieu = "Studio One Step"; @evt.adresse = "18, rue Fb du Temple "; @evt.cp = "75011"; @evt.ville = "Paris"; @evt.pays = "France"; @evt.reduit = ""; @evt.transport = "M° République - sortie 4"; @evt.contact = ""; @evt.user = @user; @evt.set_search; @evt.save

@user = User.find_by(email: "bodyvoiceandbeing@gmail.com")

  @evt = Event.new; @evt.titre = "LE CORPS DE LA VOIX, LE CHANT DU CORPS"; @evt.description = "Cours de 5 rythmes"; @evt.debut = DateTime.new( 2018  ,  10 ,  2  ,  12 ,  30 ); @evt.fin = DateTime.new(  2018  ,  10 ,  2  ,  17 ,  30 ); @evt.prix =   60 ; @evt.lieu = "La Guillotine"; @evt.adresse = "24, rue Robespierre"; @evt.cp = "93100"; @evt.ville = "Montreuil"; @evt.pays = "France"; @evt.reduit = " 165€ pour trois, 350€ les 7"; @evt.transport = "M° Robespierre"; @evt.contact = ""; @evt.user = @user; @evt.set_search; @evt.save

@user = User.find_by(email: "inmotioneurope@gmail.com")

  @evt = Event.new; @evt.titre = "L’Arbre de Vie"; @evt.description = "Movement medecine"; @evt.debut = DateTime.new( 2016  ,  8  ,  30 ,  19 ,  0  ); @evt.fin = DateTime.new( 2016  ,  8  ,  30 ,  22 ,  0  ); @evt.prix =   20 ; @evt.lieu = "Micadanses - Studio May B"; @evt.adresse = "15, rue Geoffroy L Asnier"; @evt.cp = "75004"; @evt.ville = "Paris"; @evt.pays = "France"; @evt.reduit = "15 € - 12 €"; @evt.transport = "M° St Paul"; @evt.contact = ""; @evt.user = @user; @evt.set_search; @evt.save

@user = User.find_by(email: "ozedait@gmail.com")

  for i in 0..23
  @evt = Event.new; @evt.title = "Vague Danse des 5 Rythmes"; @evt.description = "Vague Danse des 5 Rythmes"; @evt.begin = DateTime.new( 2018  ,  1  ,  19  ,  19 ,  30 ) + (i*7).days; @evt.end = DateTime.new( 2018  ,  1  ,  19  ,  21 ,  45 ) + (i*7).days; @evt.price_max =   20 ; @evt.price_min =   15 ; @evt.adress = "Studio One Step, 18, rue Fb du Temple "; @evt.zip = "75011"; @evt.town = "Paris"; @evt.organizer = @user; @evt.save
  end


@user = User.find_by(email: "lnerot@yahoo.fr")
