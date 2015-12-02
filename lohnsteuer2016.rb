# coding: utf-8
require_relative 'lst2016'

class Lohnsteuer2016
  def self.calculate(options = {})
    overrides = {
      STKL: options[:tax_class] || 1,
      LZZ: map_period(options[:period]) || 1,
      RE4: options[:salary] * 100 || 0,
      ZKF: options[:children] || 0,
      PVZ: options[:no_nursing_care_insurance] ? 0 : 1
    }

    raw = LST2016.new(input_values.merge(overrides)).LST2016.output

    {
      income_tax: ((raw[:LSTLZZ] + raw[:STS] + raw[:STV]) / 100.0).floor,
      solidarity_surcharge: ((raw[:SOLZLZZ] + raw[:SOLZS] + raw[:SOLZV]) / 100.0).floor
    }
  end

  def self.map_period(period)
    { year: 1, month: 2, week: 3, day: 4 }.fetch(period, nil)
  end

  private

  def self.input_values
    {
      # 1, wenn die Anwendung des Faktorverfahrens gewaehlt wurde (nur
      # in Steuerklasse IV)
      AF: 0,

      # Auf die Vollendung des 64. Lebensjahres folgendes Kalenderjahr
      # (erforderlichen wenn ALTER1=1)
      AJAHR: 0,

      # 1, wenn das 64. Lebensjahr vor Beginn des Kalenderjahres
      # vollendet wurde, in dem der Lohnzahlungszeitraums endet (§ 24a
      # EStG), sonst = 0
      ALTER1: 0,

      # In VKAPA und VMT enthaltene Entschädigungen nach § 24 Nummer 1
      # EStG in Cent
      ENTSCH: 0,

      # eingetragener Faktor mit drei Nachkommastellen
      F: 0,

      # Jahresfreibetrag fuer die Ermittlung der Lohnsteuer fuer die
      # sonstigen Bezuege nach Massgabe der elektronischen
      # Lohnsteuerabzugsmerkmale nach § 39e EStG oder der
      # Eintragung auf der Bescheinigung fuer den Lohnsteuerabzug 2016
      # in Cent
      JFREIB: 0,

      # Jahreshinzurechnungsbetrag für die Ermittlung der Lohnsteuer
      # für die sonstigen Bezüge nach Maßgabe der elektronischen
      # Lohnsteuerabzugsmerkmale nach § 39e EStG oder der Eintragung
      # auf der Bescheinigung für den Lohnsteuerabzug 2016 in Cent
      # (ggf. 0)
      JINZU: 0,

      # Voraussichtlicher Jahresarbeitslohn ohne sonstige Bezüge und
      # ohne Vergütung fuer mehrjährige Tätigkeit in Cent
      JRE4: 0,

      # In JRE4 enthaltene Entschädigung nach § 24 Nummer 1 EStG in
      # Cent
      JRE4ENT: 0,

      # In JRE4 enthaltene Versorgungsbezuege in Cent (ggf. 0)
      JVBEZ: 0,

      # Merker fuer die Vorsorgepauschale
      KRV: 0,

      # Kassenindividueller Zusatzbeitragssatz bei einem gesetzlich
      # krankenversicherten Arbeitnehmer in Prozent (bspw. 1.10 für
      # 1,10 %) mit 2 Dezimalstellen
      KVZ: 1.10,

      # Lohnzahlungszeitraum:
      #
      # 1 = Jahr
      # 2 = Monat
      # 3 = Woche
      # 4 = Tag
      LZZ: 2,

      # Der als elektronisches Lohnsteuerabzugsmerkmal fuer den
      # Arbeitnehmer
      LZZFREIB: 0,

      # Der als elektronisches Lohnsteuerabzugsmerkmal fuer den
      # Arbeitgeber
      LZZHINZU: 0,

      # Dem Arbeitgeber mitgeteilte Beiträge des Arbeitnehmers für
      # eine private Basiskranken- bzw. Pflege-Pflichtversicherung im
      # Sinne des §10 Absatz 1 Nummer 3 EStG in Cent; der Wert ist
      # unabhängig vom Lohnzahlungszeitraum immer als Monatsbetrag
      # anzugeben
      PKPV: 0,

      # 0 = gesetzlich krankenversicherte Arbeitnehmer
      #
      # 1 = ausschließlich privat krankenversicherte Arbeitnehmer ohne
      #     Arbeitgeberzuschuss
      #
      # 2 = ausschließlich privat krankenversicherte Arbeitnehmer mit
      #     Arbeitgeberzuschuss
      PKV: 0,

      # 1, wenn bei der sozialen Pflegeversicherung die Besonderheiten
      # in Sachsen zu berücksichtigen sind bzw. zu berücksichtigen
      # wären
      PVS: 0,

      # 1, wenn der Arbeitnehmer den Zuschlag zur sozialen
      # Pflegeversicherung zu zahlen hat
      PVZ: 0,

      # Religionsgemeinschaft des Arbeitnehmers lt. elektronischer
      # Lohnsteuerabzugsmerkmale oder der Bescheinigung fuer den
      # Lohnsteuerabzug 2016 (bei keiner Religionszugehörigkeit = 0)
      R: 0,

      # Steuerpflichtiger Arbeitslohn vor Berücksichtigung des
      # Versorgungsfreibetrags und des Zuschlags zum
      # Versorgungsfreibetrag, des Altersentlastungsbetrags und des
      # als elektronisches Lohnsteuerabzugsmerkmal festgestellten oder
      # in der Bescheinigung für den Lohnsteuerabzug 2016 für den
      # Lohnzahlungszeitraum eingetragenen Freibetrags
      # bzw. Hinzurechnungsbetrags in Cent
      RE4: 0,

      # Sonstige Bezüge (ohne Vergütung aus mehrjähriger Tätigkeit)
      # einschließlich Sterbegeld bei Versorgungsbezügen sowie
      # Kapitalauszahlungen/Abfindungen, soweit es sich nicht um
      # Bezüge für mehrere Jahre handelt in Cent (ggf. 0)
      SONSTB: 0,

      # Sterbegeld bei Versorgungsbezügen sowie
      # Kapitalauszahlungen/Abfindungen, soweit es sich nicht um
      # Bezüge für mehrere Jahre handelt (in SONSTB enthalten) in Cent
      STERBE: 0,

      # Steuerklasse:
      # 1 = I
      # 2 = II
      # 3 = III
      # 4 = IV
      # 5 = V
      # 6 = VI
      STKL: 1,

      # In RE4 enthaltene Versorgungsbezüge in Cent (ggf. 0)
      # ggf. unter Berücksichtigung einer geänderten
      # Bemessungsgrundlage nach § 19 Absatz 2 Satz 10 und 11 EStG
      VBEZ: 0,

      # Versorgungsbezug im Januar 2005 bzw. für den ersten vollen
      # Monat, wenn der Versorgungsbezug erstmalig nach Januar 2005
      # gewährt wurde in Cent
      VBEZM: 0,

      # Voraussichtliche Sonderzahlungen von Versorgungsbezügen im
      # Kalenderjahr des Versorgungsbeginns bei Versorgungsempfängern
      # ohne Sterbegeld, Kapitalauszahlungen/Abfindungen in Cent
      VBEZS: 0,

      # In SONSTB enthaltene Versorgungsbezüge einschließlich
      # Sterbegeld in Cent (ggf. 0)
      VBS: 0,

      # Jahr, in dem der Versorgungsbezug erstmalig gewährt wurde;
      # werden mehrere Versorgungsbezüge gezahlt, wird aus
      # Vereinfachungsgründen für die Berechnung das Jahr des ältesten
      # erstmaligen Bezugs herangezogen
      VJAHR: 0,

      # Entschädigungen / Kapitalauszahlungen / Abfindungen /
      # Nachzahlungen bei Versorgungsbezügen für mehrere Jahre in Cent
      # (ggf. 0)
      VKAPA: 0,

      # Entschädigungen und Vergütung für mehrjährige Tätigkeit ohne
      # Kapitalauszahlungen und ohne Abfindungen bei
      # Versorgungsbezügen in Cent (ggf. 0)
      VMT: 0,

      # Zahl der Freibetraege fuer Kinder (eine Dezimalstelle, nur bei
      # Steuerklassen I, II, III und IV)
      ZKF: 0,

      # Zahl der Monate, für die im Kalenderjahr Versorgungsbezüge
      # gezahlt werden [nur erforderlich bei Jahresberechnung (LZZ =
      # 1)]
      ZMVB: 0
    }
  end
end
