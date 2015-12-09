require 'date'

# Source: https://www.bmf-steuerrechner.de/pruefdaten/pap2015Dezember.pdf
class Lst1215
  def self.applies?(date)
    (Date.new(2015, 12, 1) .. Date.new(2015, 12, 31)).include?(date)
  end

  def initialize(params)
    %i(AF AJAHR ALTER1 ENTSCH F JFREIB JHINZU JRE4 JRE4ENT JVBEZ
       KRV KVZ LZZ LZZFREIB LZZHINZU PKPV PKV PVS PVZ R RE4 SONSTB SONSTENT STERBE STKL
       VBEZ VBEZM VBEZS VBS VJAHR VKAPA VMT ZKF ZMVB).each do |key|
      instance_variable_set(:"@#{key}", params[key] || 0)
    end
  end

  def output
    %i(BK BKS BKV LSTLZZ SOLZLZZ SOLZS SOLZV STS STV VKVLZZ VKVSONST).map do |var|
      [var, instance_variable_get(:"@#{var}").to_i]
    end.to_h
  end

  def LST1215
    self.MPARA
    self.MRE4JL
    @VBEZBSO = 0
    @KENNVMT = 0
    self.MRE4
    self.MRE4ABZ
    @ZRE4VPM = @ZRE4VP
    @SCHLEIFZ = 1
    self.MBERECH
    @SCHLEIFZ = 2
    @W1STKL5 = 9_873
    @ZRE4VP = @ZRE4VPM
    self.MBERECH
    self.MLST1215
    self.MSONST
    self.MVMT

    output
  end

  def MPARA
    if @KRV < 2
      if @KRV == 0
        @BBGRV = 72_600.0
      else
        @BBGRV = 62_400.0
      end
      @RVSATZAN = 0.0935
      @TBSVORV = 0.60
    end

    @BBGKVPV = 49_500.0
    @KVSATZAN = @KVZ / 100.0 + 0.07
    @KVSATZAG = 0.07

    if @PVS == 1
      @PVSATZAN = 0.01675
      @PVSATZAG = 0.00675
    else
      @PVSATZAN = 0.01175
      @PVSATZAG = 0.01175
    end

    if @PVZ == 1
      @PVSATZAN = @PVSATZAN + 0.0025
    end

    @W1STKL5 = 9_763
    @W2STKL5 = 26_441
    @W3STKL5 = 200_584
  end

  def MRE4JL
    if @LZZ == 1
      @ZRE4J = @RE4 / 100.0
      @ZVBEZJ = @VBEZ / 100.0
      @JLFREIB = @LZZFREIB / 100.0
      @JLHINZU = @LZZHINZU / 100.0
    elsif @LZZ == 2
      @ZRE4J = @RE4 * 12 / 100.0
      @ZVBEZJ = @VBEZ * 12 / 100.0
      @JLFREIB = @LZZFREIB * 12 / 100.0
      @JLHINZU = @LZZHINZU * 12 / 100.0
    elsif @LZZ == 3
      @ZRE4J = @RE4 * 360 / 7.0 / 100.0
      @ZVBEZJ = @VBEZ * 360.0 / 7.0 / 100.0
      @JLFREIB = @LZZFREIB * 360.0 / 7.0 / 100.0
      @JLHINZU = @LZZHINZU * 360.0 / 7.0 / 100.0
    else
      @ZRE4J = @RE4 * 360 / 100.0
      @ZVBEZJ = @VBEZ * 360.0 / 100.0
      @JLFREIB = @LZZFREIB * 360.0 / 100.0
      @JLHINZU = @LZZHINZU * 360.0 / 100.0
    end

    if @AF == 0
      @F = 1
    end
  end

  def MRE4
    if @ZVBEZJ == 0
      @FVBZ = 0
      @FVB = 0
      @FVBZSO = 0
      @FVBSO = 0
    else
      if @VJAHR < 2006
        @J = 1
      elsif @VJAHR < 2040
        @J = @VJAHR - 2004
      else
        @J = 36
      end

      if @LZZ == 1
        @VBEZB = @VBEZM * @ZMVB + @VBEZS
        @HFVB = @TAB2_J / 12.0 * @ZMVB
        @FVBZ = (@TAB3_J / 12.0 * @ZMVB).ceil.to_f
      else
        @VBEZB = @VBEZM * 12 + @VBEZS
        @HFVB = @TAB2_J
        @FVBZ = @TAB3_J
      end
      @FVB = (@VBEZB * @TAB1_J).ceil / 100.0
      if @FVB > @HFVB
        @FVB = @HFVB
      end
      @FVBSO = (@FVB + @VBEZBSO * @TAB1_J).ceil / 100.0
      if @FVBSO > @TAB2_J
        @FVBSO = @TAB2_J
      end
      @HFVBZSO = (@VBEZB + @VBEZBSO) / 100.0 - @FVBSO
      @FVBZSO = (@FVBZ + @VBEZBSO / 100.0).ceil.to_f
      if @FVBZSO > @HFVBZSO
        @FBVZSO = @HFVBZSO.ceil.to_f
      end
      if @FVBZSO > @TAB3_J
        @FVBZSO = @TAB3_J
      end
      @HFVBZ = @VBEZB / 100.0 - @FVB
      if @FVBZ > @HFVBZ
        @FVBZ = @HFVBZ.ceil.to_f
      end
    end
    self.MRE4ALTE
  end

  def MRE4ALTE
    if @ALTER1 == 0
      @ALTE = 0
    else
      if @AJAHR < 2006
        @K = 1
      elsif @AJAHR < 2040
        @K = @AJAHR - 2004
      else
        @K = 36
      end
      @BMG = @ZRE4J - @ZVBEZJ
      @ALTE = (@BMG * @TAB4_K).ceil.to_f
      @HBALTE = @TAB5_K
      if @ALTE > @HBALTE
        @ALTE = @HBALTE
      end
    end
  end

  def MRE4ABZ
    @ZRE4 = @ZRE4J - @FVB - @ALTE - @JLFREIB + @JLHINZU
    if @ZRE4 < 0
      @ZRE4 = 0
    end
    @ZRE4VP = @ZRE4J
    if @KENNVMT == 2
      @ZRE4VP = @ZRE4VP - @ENTSCH / 100.0
    end
    @ZVBEZ = @ZVBEZJ - @FVB
    if @ZVBEZ < 0
      @ZVBEZ = 0
    end
  end

  def MBERECH
    if @SCHLEIFZ == 1
      self.MZTABFBA
    else
      self.MZTABFBN
    end
    self.MLSTJAHR
    @LSTJAHR = @ST * @F
    self.UPLSTLZZ
    self.UPVKVLZZ
    if @ZKF > 0
      @ZTABFB = @ZTABFB + @KFB
      self.MRE4ABZ
      self.MLSTJAHR
      @JBMG = @ST * @F
    else
      @JBMG = @LSTJAHR
    end
    self.MSOLZ
  end

  def MZTABFBA
    @ANP = 0
    if @ZVBEZ >= 0
      if @ZVBEZ < @FVBZ
        @FVBZ = @ZVBEZ
      end
    end
    if @STKL < 6
      if @ZVBEZ > 0
        if @ZVBEZ - @FVBZ < 102
          @ANP = (@ZVBEZ - @FVBZ).ceil.to_f
        else
          @ANP = 102
        end
      end
    else
      @FVBZ = 0
      @FVBZSO = 0
    end
    if @STKL < 6
      if @ZRE4 > @ZVBEZ
        if @ZRE4 - @ZVBEZ < 1000
          @ANP = (@ANP + @ZRE4 - @ZVBEZ).ceil.to_f
        else
          @ANP = @ANP + 1000
        end
      end
    end
    @KZTAB = 1
    if @STKL == 1
      @SAP = 36.0
      @KFB = @ZKF * 7008.0
    elsif @STKL == 2
      @EFA = 1308.0
      @SAP = 36.0
      @KFB = @ZKF * 7008.0
    elsif @STKL == 3
      @KZTAB = 2
      @SAP = 36
      @KFB = @ZKF * 7008.0
    elsif @STKL == 4
      @SAP = 36
      @KFB = @ZKF * 3504.0
    elsif @STKL == 5
      @SAP = 36
      @KFB = 0
    else
      @KFB = 0
    end
    @ZTABFB = @EFA.to_f + @ANP.to_f + @SAP.to_f + @FVBZ.to_f
  end

  def MZTABFBN
    @ANP = 0
    if @ZVBEZ >= 0
      if @ZVBEZ < @FVBZ
        @FVBZ = @ZVBEZ
      end
    end
    if @STKL < 6
      if @ZVBEZ > 0
        if @ZVBEZ - @FVBZ < 102
          @ANP = (@ZVBEZ - @FVBZ).ceil
        else
          @ANP = 102
        end
      end
    else
      @FVBZ = 0
      @FVBZSO = 0
    end
    if @STKL < 6
      if @ZRE4 > @ZVBEZ
        if @ZRE4 - @ZVBEZ < 1000
          @ANP = @ANP + @ZRE4 - @ZVBEZ
        else
          @ANP = @ANP + 1000
        end
      end
    end
    @KZTAB = 1
    if @STKL == 1
      @SAP = 36
      @KFB = @ZKF * 7152.0
    elsif @STKL == 2
      @EFA = 1908
      @SAP = 36
      @KFB = @ZKF * 7152.0
    elsif @STKL == 3
      @KZTAB = 2
      @SAP = 36
      @KFB = @ZKF * 7152.0
    elsif @STKL == 4
      @SAP = 36
      @KFB = @ZKF * 3576.0
    elsif @STKL == 5
      @SAP = 36
      @KFB = 0
    else
      @KFB = 0
    end
    @ZTABFB = @EFA.to_f + @ANP.to_f + @SAP.to_f + @FVBZ.to_f
  end

  def MLSTJAHR
    self.UPEVP
    if @KENNVMT != 1
      @ZVE = @ZRE4 - @ZTABFB - @VSP
      self.UPMLST
    else
      @ZVE = @ZRE4 - @ZTABFB - @VSP - @VMT / 100.0 - @VKAPA / 100.0
      if @ZVE < 0
        @ZVE = (@ZVE + @VMT / 100.0 + @VKAPA / 100.0) / 5.0
        self.UPMLST
        @ST = @ST * 5
      else
        self.UPMLST
        @STOVMT = @ST
        @ZVE = @ZVE + (@VMT + @VKAPA) / 500
        self.UPMLST
        @ST = (@ST - @STOVMT) * 5 + @STOVMT
      end
    end
  end

  def UPVKVLZZ
    self.UPVKV
    @JW = @VKV
    self.UPANTEIL
    @VKLZZ = @ANTEIL1
  end

  def UPVKV
    if @PKV > 0
      if @VSP2 > @VSP3
        @VKV = @VSP2 * 100.0
      else
        @VKV = @VSP3 * 100.0
      end
    else
      @VKV = 0
    end
  end

  def UPLSTLZZ
    @JW = @LSTJAHR * 100.0
    if @SCHLEIFZ == 1
      @JWLSTA = @JW
    else
      @JWLSTN = @JW
    end
    self.UPANTEIL
    @LSTLZZ = @ANTEIL1
  end

  def UPMLST
    if @ZVE < 1
      @ZVE = 0
      @X = 0
    else
      @X = (@ZVE.to_f / @KZTAB.to_f).floor.to_f
    end
    if @STKL < 5
      if @SCHLEIFZ == 1
        self.UPTAB14
      else
        self.UPTAB15
      end
    else
      self.MST5_6
    end
  end

  def UPEVP
    if @KRV > 1
      @VSP1 = 0
    else
      if @ZRE4VP > @BBGRV
        @ZRE4VP = @BBGRV
      end
      @VSP1 = @TBSVORV * @ZRE4VP
      @VSP1 = @VSP1 * @RVSATZAN
    end
    @VSP2 = 0.12 * @ZRE4VP
    if @STKL == 3
      @VHB = 3000.0
    else
      @VHB = 1900.0
    end
    if @VSP2 > @VHB
      @VSP2 = @VHB
    end
    @VSPN = (@VSP1 + @VSP2).ceil.to_f
    self.MVSP
    if @VSPN > @VSP
      @VSP = @VSPN
    end
  end

  def MVSP
    if @ZRE4VP > @BBGKVPV
      @ZRE4VP = @BBGKVPV
    end
    if @PKV > 0
      if @STKL == 6
        @VSP3 = 0
      else
        @VSP3 = @PKPV * 12.0 / 100.0
        if @PKV == 2
          @VSP3 = @VSP3 - @ZRE4VP * (@KVSATZAG + @PVSATZAG)
        end
      end
    else
      @VSP3 = @ZRE4VP * (@KVSATZAN + @PVSATZAN)
    end
    @VSP = (@VSP3 + @VSP1).ceil.to_f
  end

  def MST5_6
    @ZZX = @X
    if @ZZX > @W2STKL5
      @ZX = @W2STKL5
      self.UP5_6
      if @ZZX > @W3STKL5
        @ST = (@ST + (@W3STKL5 - @W2STKL5) * 0.42).floor.to_f
        @ST = (@ST + (@ZZX - @W3STKL5) * 0.45).floor.to_f
      else
        @ST = (@ST + (@ZZX - @W2STKL5) * 0.42).floor.to_f
      end
    else
      @ZX = @ZZX
      self.UP5_6
      if @ZZX > @W1STKL5
        @VERGL = @ST
        @ZX = @W1STKL5
        self.UP5_6
        @HOCH = (@ST + (@ZZX - @W1STKL5) * 0.42).floor.to_f
        if @HOCH < @VERGL
          @ST = @HOCH
        else
          @ST = @VERGL
        end
      end
    end
  end

  def UP5_6
    @X = @ZX * 1.25
    if @SCHLEIFZ == 1
      self.UPTAB14
    else
      self.UPTAB15
    end
    @ST1 = @ST
    @X = @ZX * 0.75
    if @SCHLEIFZ == 1
      self.UPTAB14
    else
      self.UPTAB15
    end
    @ST2 = @ST
    @DIFF = (@ST1 - @ST2) * 2
    @MIST = (@ZX * 0.14).floor.to_f
    if @MIST > @DIFF
      @ST = @MIST
    else
      @ST = @DIFF
    end
  end

  def MSOLZ
    @SOLZFREI = 972.0 * @KZTAB
    if @JBMG > @SOLZFREI
      @SOLZJ = (@JBMG * 5.5).floor / 100.0
      @SOLZMIN = (@JBMG - @SOLZFREI) * 20.0 / 100.0
      if @SOLZMIN < @SOLZJ
        @SOLZJ = @SOLZMIN
      end
      @JW = @SOLZJ * 100.0
      if @SCHLEIFZ == 1
        @JWSOLZA = @JW
      else
        @JWSOLZN = @JW
      end
      self.UPANTEIL
      @SOLZLZZ = @ANTEIL1
    else
      @SOLZLZZ = 0
    end
    if @R > 0
      @JW = @JBMG * 100.0
      if @SCHLEIFZ == 1
        @JWBKA = @JW
      else
        @JWBKN = @JW
      end
      self.UPANTEIL
      @BK = @ANTEIL1
    else
      @BK = 0
    end
  end

  def MLST1215
    if @LZZ > 1
      @JW = @JWLSTN - 11 * (@JWLSTA - @JWLSTN)
      if @JW < 0
        @ANTEIL1 = 0
      else
        self.UPANTEIL
      end
      @LSTLZZ = @ANTEIL1
      @JW = @JWSOLZN - 11 * (@JWSOLZA - @JWSOLZN)
      if @JW < 0
        @ANTEIL1 = 0
      else
        self.UPANTEIL
      end
      @SOLZLZZ = @ANTEIL1
      @JW = @JWBKN.to_f - 11 * (@JWBKA.to_f - @JWBKN.to_f)
      if @JW < 0
        @ANTEIL1 = 0
      else
        self.UPANTEIL
      end
      @BK = @ANTEIL1
    end
  end

  def UPANTEIL
    if @LZZ == 1
      @ANTEIL1= @JW
    elsif @LZZ == 2
      @ANTEIL1 = (@JW / 12.0).floor.to_f
    elsif @LZZ == 3
      @ANTEIL1 = (@JW * 7.0 / 360).floor.to_f
    else
      @ANTEIL1 = (@JW / 360.0).floor.to_f
    end
  end

  def MSONST
    @LZZ = 1
    if @ZMVB == 0
      @ZMVB = 12
    end
    if @SONSTB == 0
      @VKVSONST = 0
      @LSTSO = 0
      @STS = 0
      @SOLZS = 0
      @BKS = 0
    else
      self.MOSONST
      self.UPVKV
      @VKVSONST = @VKV
      @ZRE4J = (@JRE4 + @SONSTB) / 100.0
      @ZVBEZJ = (@JVBEZ + @VBS) / 100.0
      @VBEZBSO = @STERBE
      self.MRE4SONST
      self.MLSTJAHR
      @WVFRBM = (@ZVE - @GFB) * 100.0
      if @WVFRBM < 0
        @WVFRBM = 0
      end
      self.UPVKV
      @VKVSONST = @VKV - @VKVSONST
      @LSTSO = @ST * 100.0
      @STS = ((@LSTSO - @LSTOSO) * @F).floor.to_f
      if @STS < 0
        @STS = 0
      end
      @SOLZS = (@STS * 5.5).floor / 100.0
      if @R > 0
        @BKS = @STS
      else
        @BKS = 0
      end
    end
  end

  def MVMT
    if @VKAPA < 0
      @VKAPA = 0
    end
    if @VMT + @VKAPA > 0
      if @LSTSO == 0
        self.MOSONST
        @LST1 = @LSTOSO
      else
        @LST1 = @LSTSO
      end
      @VBEZBSO = @STERBE + @VKAPA
      @ZRE4J = (@JRE4 + @SONSTB + @VMT + @VKAPA) / 100.0
      @ZVBEZJ = (@JVBEZ + @VBS + @VKAPA) / 100.0
      @KENNVMT = 2
      self.MRE4SONST
      self.MLSTJAHR
      @LST3 = @ST * 100.0
      self.MRE4ABZ
      @ZRE4VP = @ZRE4VP - @JRE4ENT / 100.0 - @SONSTENT / 100.0
      @KENNVMT = 1
      self.MLSTJAHR
      @LST2 = @ST * 100.0
      @STV = @LST2 - @LST1
      @LST3 = @LST3 - @LST1
      if @LST3 < @STV
        @STV = @LST3
      end
      if @STV < 0
        @STV = 0
      else
        @STV = (@STV * @F).floor.to_f
      end
      @SOLZV = (@STV * 5.5).floor / 100.0
      if @R > 0
        @BKV = @STV
      else
        @BKV = 0
      end
    else
      @STV = 0
      @SOLZV = 0
      @BKV = 0
    end
  end

  def MOSONST
    @ZRE4J = @JRE4 / 100.0
    @ZVBEZJ = @JVBEZ / 100.0
    @JLFREIB = @JFREIB / 100.0
    @JLHINZU = @JHINZU / 100.0
    self.MRE4
    self.MRE4ABZ
    @ZRE4VP = @ZRE4VP - @JRE4ENT / 100.0
    self.MZTABFBN
    self.MLSTJAHR
    @LSTOSO = @ST * 100
  end

  def MRE4SONST
    self.MRE4
    @FVB = @FVBSO
    self.MRE4ABZ
    @ZRE4VP = @ZRE4VP - @JRE4ENT / 100.0 - @SONSTENT / 100.0
    @FVBZ = @FVBZSO
    self.MZTABFBN
  end

  def UPTAB14
    if @X < 8355
      @ST = 0
    else
      if @X < 13_470
        @Y = (@X - 8354) / 10_000
        @RW = @Y * 974.58
        @RW = @RW + 1_400.0
        @ST = (@RW * @Y).floor
      elsif @X < 52_882
        @Y = (@X - 13_469.0) / 10_000
        @RW = (@Y * 228.74)
        @RW = @RW + 2_397.0
        @RW = @RW * @Y
        @ST = (@RW + 971.0).floor
      elsif @X < 250_731
        @ST = (@X * 0.42 - 8239.0).floor
      else
        @ST = (@X * 0.45 - 15_761.0).floor
      end
      @ST = (@ST * @KZTAB).floor
    end
  end

  def UPTAB15
    if @X < 8473
      @ST = 0
    else
      if @X < 13_470
        @Y = (@X - 8472) / 10_000
        @RW = @Y * 997.6
        @RW = @RW + 1_400.0
        @ST = (@RW * @Y).floor
      elsif @X < 52_882
        @Y = (@X - 13_469.0) / 10_000
        @RW = @Y * 228.74
        @RW = @RW + 2_397.0
        @RW = @RW * @Y
        @ST = (@RW + 948.68).floor
      elsif @X < 250_731
        @ST = (@X * 0.42 - 8261.29).floor
      else
        @ST = (@X * 0.45 - 15_783.19).floor
      end
      @ST = @ST * @KZTAB
    end
  end
end
