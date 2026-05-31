import 'package:flutter/material.dart';

/// Paleta de cores do Flora como ThemeExtension.
///
/// Permite suporte a temas (claro/escuro/alto contraste).
/// Acesse via `Theme.of(context).extension<AppColors>()!` ou `context.colors`.
class AppColors extends ThemeExtension<AppColors> {
  // ─── Superfícies ────────────────────────────────────────────────────
  final Color headerBg;
  final Color surface;
  final Color scaffoldBg;
  final Color surfaceCard;

  // ─── Texto ──────────────────────────────────────────────────────────
  final Color ink;
  final Color inkDark;
  final Color subInk;
  final Color subInkLight;

  // ─── Cartões ────────────────────────────────────────────────────────
  final Color cardBeige;
  final Color cardGreen;
  final Color cardCream;
  final Color beigeBox;

  // ─── Botões ─────────────────────────────────────────────────────────
  final Color btnPrimary;
  final Color btnSecondary;
  final Color btnAction;

  // ─── Status ─────────────────────────────────────────────────────────
  final Color successGreen;
  final Color statusPendenteBg;
  final Color statusPendenteTxt;
  final Color statusEntregueBg;
  final Color statusEntregueTxt;
  final Color statusVerificadoBg;
  final Color statusVerificadoTxt;

  // ─── Erro ───────────────────────────────────────────────────────────
  final Color errorBg;
  final Color errorText;

  // ─── Stat cards ─────────────────────────────────────────────────────
  final Color statGreenBg;
  final Color statGreenOrb;
  final Color statGreenTxt;
  final Color statYellowBg;
  final Color statYellowOrb;
  final Color statYellowTxt;
  final Color statPinkBg;
  final Color statPinkOrb;
  final Color statPinkTxt;

  // ─── Navegação ──────────────────────────────────────────────────────
  final Color navBg;
  final Color navBorder;
  final Color navFabBg;
  final Color navActive;

  // ─── Bordas e Filtros ───────────────────────────────────────────────
  final Color borderLight;
  final Color borderCard;
  final Color borderFilter;
  final Color filterBg;
  final Color filterTxt;

  // ─── Quick actions ──────────────────────────────────────────────────
  final Color quickCardBg;
  final Color quickBtnBg;
  final Color quickTxt;

  // ─── Progresso ──────────────────────────────────────────────────────
  final Color progressBg;
  final Color progressFill;

  // ─── Cadastro ───────────────────────────────────────────────────────
  final Color cadastroAlunoBg;
  final Color cadastroProfBg;
  final Color cadastroAlunoBorder;
  final Color cadastroProfBorder;
  final Color inputBg;
  final Color inputBorder;

  // ─── Gráficos ───────────────────────────────────────────────────────
  final Color chartBarColor;
  final Color chartBg;
  final Color pieBg;

  const AppColors({
    required this.headerBg,
    required this.surface,
    required this.scaffoldBg,
    required this.surfaceCard,
    required this.ink,
    required this.inkDark,
    required this.subInk,
    required this.subInkLight,
    required this.cardBeige,
    required this.cardGreen,
    required this.cardCream,
    required this.beigeBox,
    required this.btnPrimary,
    required this.btnSecondary,
    required this.btnAction,
    required this.successGreen,
    required this.statusPendenteBg,
    required this.statusPendenteTxt,
    required this.statusEntregueBg,
    required this.statusEntregueTxt,
    required this.statusVerificadoBg,
    required this.statusVerificadoTxt,
    required this.errorBg,
    required this.errorText,
    required this.statGreenBg,
    required this.statGreenOrb,
    required this.statGreenTxt,
    required this.statYellowBg,
    required this.statYellowOrb,
    required this.statYellowTxt,
    required this.statPinkBg,
    required this.statPinkOrb,
    required this.statPinkTxt,
    required this.navBg,
    required this.navBorder,
    required this.navFabBg,
    required this.navActive,
    required this.borderLight,
    required this.borderCard,
    required this.borderFilter,
    required this.filterBg,
    required this.filterTxt,
    required this.quickCardBg,
    required this.quickBtnBg,
    required this.quickTxt,
    required this.progressBg,
    required this.progressFill,
    required this.cadastroAlunoBg,
    required this.cadastroProfBg,
    required this.cadastroAlunoBorder,
    required this.cadastroProfBorder,
    required this.inputBg,
    required this.inputBorder,
    required this.chartBarColor,
    required this.chartBg,
    required this.pieBg,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA CLARO (padrão atual)
  // ═══════════════════════════════════════════════════════════════════════════
  static const _light = AppColors(
    headerBg: Color(0xFF97C2C1),
    surface: Color(0xFFFEF9F2),
    scaffoldBg: Color(0xFFB4D4D3),
    surfaceCard: Colors.white,
    ink: Color(0xFF304F55),
    inkDark: Color(0xFF233B3E),
    subInk: Color(0xFF424849),
    subInkLight: Color(0xFF999999),
    cardBeige: Color(0xFFE8E0B0),
    cardGreen: Color(0xFFCDE5E5),
    cardCream: Color(0xFFFFF4EA),
    beigeBox: Color(0xFFFCF6EE),
    btnPrimary: Color(0xFF233B3E),
    btnSecondary: Color(0xFF678D8A),
    btnAction: Color(0xFF47967D),
    successGreen: Color(0xFF5F8D4E),
    statusPendenteBg: Color(0xFFFDE8E9),
    statusPendenteTxt: Color(0xFFE57373),
    statusEntregueBg: Color(0xFFFFF4DB),
    statusEntregueTxt: Color(0xFFD4A33B),
    statusVerificadoBg: Color(0xFFD8EFEB),
    statusVerificadoTxt: Color(0xFF086652),
    errorBg: Color(0xFFFFCCCC),
    errorText: Color(0xFFCC0000),
    statGreenBg: Color(0xFFDCF3ED),
    statGreenOrb: Color.fromRGBO(30, 51, 55, 0.08),
    statGreenTxt: Color(0xFF1E3337),
    statYellowBg: Color(0xFFE8E0B0),
    statYellowOrb: Color.fromRGBO(76, 82, 61, 0.08),
    statYellowTxt: Color(0xFF4C523D),
    statPinkBg: Color(0xFFEFCECB),
    statPinkOrb: Color.fromRGBO(80, 47, 48, 0.08),
    statPinkTxt: Color(0xFF502F30),
    navBg: Color(0xFFBFDDDC),
    navBorder: Color(0xFF9CBBBA),
    navFabBg: Color(0xFFB4D4D3),
    navActive: Color(0xFFFEF9F2),
    borderLight: Color(0xFFDED1BC),
    borderCard: Color(0xFFE8DFD3),
    borderFilter: Color(0xFFB2D4CC),
    filterBg: Color(0xFFE5EFEC),
    filterTxt: Color(0xFF47967D),
    quickCardBg: Color(0xFFFCD4A4),
    quickBtnBg: Color(0xFFFFBC69),
    quickTxt: Color(0xFF6D4A1B),
    progressBg: Color(0xFFCDE5E5),
    progressFill: Color(0xFF678D8A),
    cadastroAlunoBg: Color(0xFFE0F0EF),
    cadastroProfBg: Color(0xFFF5DEDA),
    cadastroAlunoBorder: Color(0xFFB5D5D3),
    cadastroProfBorder: Color(0xFFDFB8B3),
    inputBg: Colors.white,
    inputBorder: Color(0xFFD5CDC2),
    chartBarColor: Color(0xFF97C2C1),
    chartBg: Color(0xFFE0F0EF),
    pieBg: Color(0xFFF5DEDA),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA ESCURO
  // ═══════════════════════════════════════════════════════════════════════════
  static const _dark = AppColors(
    headerBg: Color(0xFF1A2F32),
    surface: Color(0xFF1E2A2C),
    scaffoldBg: Color(0xFF141F21),
    surfaceCard: Color(0xFF253538),
    ink: Color(0xFFD4E8E7),
    inkDark: Color(0xFFE8F4F3),
    subInk: Color(0xFFABBEC0),
    subInkLight: Color(0xFF6B8082),
    cardBeige: Color(0xFF3A3828),
    cardGreen: Color(0xFF1E3335),
    cardCream: Color(0xFF2C2820),
    beigeBox: Color(0xFF252220),
    btnPrimary: Color(0xFF7DBAB8),
    btnSecondary: Color(0xFF5A9E9A),
    btnAction: Color(0xFF4DAF8E),
    successGreen: Color(0xFF6CA65B),
    statusPendenteBg: Color(0xFF3D2020),
    statusPendenteTxt: Color(0xFFEF9A9A),
    statusEntregueBg: Color(0xFF3D3420),
    statusEntregueTxt: Color(0xFFE8C860),
    statusVerificadoBg: Color(0xFF1A3530),
    statusVerificadoTxt: Color(0xFF4ECFA5),
    errorBg: Color(0xFF3D2020),
    errorText: Color(0xFFFF6B6B),
    statGreenBg: Color(0xFF1A3530),
    statGreenOrb: Color.fromRGBO(200, 230, 220, 0.08),
    statGreenTxt: Color(0xFFB5DDD0),
    statYellowBg: Color(0xFF3A3828),
    statYellowOrb: Color.fromRGBO(200, 200, 160, 0.08),
    statYellowTxt: Color(0xFFD4CFA0),
    statPinkBg: Color(0xFF3D2525),
    statPinkOrb: Color.fromRGBO(200, 160, 160, 0.08),
    statPinkTxt: Color(0xFFDEB0AD),
    navBg: Color(0xFF1E3335),
    navBorder: Color(0xFF2E4A4C),
    navFabBg: Color(0xFF253538),
    navActive: Color(0xFF2E4A4C),
    borderLight: Color(0xFF3A4A4C),
    borderCard: Color(0xFF2E3E40),
    borderFilter: Color(0xFF2E5550),
    filterBg: Color(0xFF1E3335),
    filterTxt: Color(0xFF4DAF8E),
    quickCardBg: Color(0xFF3D3020),
    quickBtnBg: Color(0xFF4D3D25),
    quickTxt: Color(0xFFE8C080),
    progressBg: Color(0xFF1E3335),
    progressFill: Color(0xFF5A9E9A),
    cadastroAlunoBg: Color(0xFF1E3335),
    cadastroProfBg: Color(0xFF3D2525),
    cadastroAlunoBorder: Color(0xFF2E5550),
    cadastroProfBorder: Color(0xFF5A3535),
    inputBg: Color(0xFF253538),
    inputBorder: Color(0xFF3A4A4C),
    chartBarColor: Color(0xFF5A9E9A),
    chartBg: Color(0xFF1E3335),
    pieBg: Color(0xFF3D2525),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA ALTO CONTRASTE
  // ═══════════════════════════════════════════════════════════════════════════
  static const _highContrast = AppColors(
    headerBg: Color(0xFF003333),
    surface: Color(0xFFF8F8F8),
    scaffoldBg: Color(0xFF004040),
    surfaceCard: Colors.white,
    ink: Color(0xFF000000),
    inkDark: Color(0xFF000000),
    subInk: Color(0xFF1A1A1A),
    subInkLight: Color(0xFF4D4D4D),
    cardBeige: Color(0xFFF5F0C0),
    cardGreen: Color(0xFFD0EFEF),
    cardCream: Color(0xFFFFF8EE),
    beigeBox: Color(0xFFFCF6EE),
    btnPrimary: Color(0xFF000000),
    btnSecondary: Color(0xFF005050),
    btnAction: Color(0xFF006040),
    successGreen: Color(0xFF006B00),
    statusPendenteBg: Color(0xFFFFDDDD),
    statusPendenteTxt: Color(0xFFCC0000),
    statusEntregueBg: Color(0xFFFFF5CC),
    statusEntregueTxt: Color(0xFF8B6B00),
    statusVerificadoBg: Color(0xFFCCF0E0),
    statusVerificadoTxt: Color(0xFF005530),
    errorBg: Color(0xFFFFCCCC),
    errorText: Color(0xFFCC0000),
    statGreenBg: Color(0xFFCCF0E0),
    statGreenOrb: Color.fromRGBO(0, 0, 0, 0.12),
    statGreenTxt: Color(0xFF003322),
    statYellowBg: Color(0xFFF5F0C0),
    statYellowOrb: Color.fromRGBO(0, 0, 0, 0.12),
    statYellowTxt: Color(0xFF333300),
    statPinkBg: Color(0xFFF0CCCC),
    statPinkOrb: Color.fromRGBO(0, 0, 0, 0.12),
    statPinkTxt: Color(0xFF330000),
    navBg: Color(0xFFCCEEEE),
    navBorder: Color(0xFF006060),
    navFabBg: Color(0xFFCCEEEE),
    navActive: Color(0xFFFFFFFF),
    borderLight: Color(0xFF666666),
    borderCard: Color(0xFF999999),
    borderFilter: Color(0xFF006060),
    filterBg: Color(0xFFDDFFFF),
    filterTxt: Color(0xFF003333),
    quickCardBg: Color(0xFFFCE0AA),
    quickBtnBg: Color(0xFFFFCC66),
    quickTxt: Color(0xFF4D3000),
    progressBg: Color(0xFFCCEEEE),
    progressFill: Color(0xFF005050),
    cadastroAlunoBg: Color(0xFFD0EFEF),
    cadastroProfBg: Color(0xFFF0CCCC),
    cadastroAlunoBorder: Color(0xFF006060),
    cadastroProfBorder: Color(0xFF880000),
    inputBg: Colors.white,
    inputBorder: Color(0xFF666666),
    chartBarColor: Color(0xFF005050),
    chartBg: Color(0xFFD0EFEF),
    pieBg: Color(0xFFF0CCCC),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // Accessors — retornam instâncias cacheadas
  // ═══════════════════════════════════════════════════════════════════════════
  static AppColors light() => _light;
  static AppColors dark() => _dark;
  static AppColors highContrast() => _highContrast;

  // ═══════════════════════════════════════════════════════════════════════════
  // Sombra padrão (não faz parte do ThemeExtension, mas é útil)
  // ═══════════════════════════════════════════════════════════════════════════
  static const BoxShadow cardShadow = BoxShadow(
    color: Color.fromRGBO(58, 82, 85, 0.05),
    blurRadius: 20,
    spreadRadius: -10,
    offset: Offset(0, 4),
  );

  @override
  AppColors copyWith({
    Color? headerBg, Color? surface, Color? scaffoldBg, Color? surfaceCard,
    Color? ink, Color? inkDark, Color? subInk, Color? subInkLight,
    Color? cardBeige, Color? cardGreen, Color? cardCream, Color? beigeBox,
    Color? btnPrimary, Color? btnSecondary, Color? btnAction,
    Color? successGreen,
    Color? statusPendenteBg, Color? statusPendenteTxt,
    Color? statusEntregueBg, Color? statusEntregueTxt,
    Color? statusVerificadoBg, Color? statusVerificadoTxt,
    Color? errorBg, Color? errorText,
    Color? statGreenBg, Color? statGreenOrb, Color? statGreenTxt,
    Color? statYellowBg, Color? statYellowOrb, Color? statYellowTxt,
    Color? statPinkBg, Color? statPinkOrb, Color? statPinkTxt,
    Color? navBg, Color? navBorder, Color? navFabBg, Color? navActive,
    Color? borderLight, Color? borderCard, Color? borderFilter,
    Color? filterBg, Color? filterTxt,
    Color? quickCardBg, Color? quickBtnBg, Color? quickTxt,
    Color? progressBg, Color? progressFill,
    Color? cadastroAlunoBg, Color? cadastroProfBg,
    Color? cadastroAlunoBorder, Color? cadastroProfBorder,
    Color? inputBg, Color? inputBorder,
    Color? chartBarColor, Color? chartBg, Color? pieBg,
  }) {
    return AppColors(
      headerBg: headerBg ?? this.headerBg,
      surface: surface ?? this.surface,
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      ink: ink ?? this.ink,
      inkDark: inkDark ?? this.inkDark,
      subInk: subInk ?? this.subInk,
      subInkLight: subInkLight ?? this.subInkLight,
      cardBeige: cardBeige ?? this.cardBeige,
      cardGreen: cardGreen ?? this.cardGreen,
      cardCream: cardCream ?? this.cardCream,
      beigeBox: beigeBox ?? this.beigeBox,
      btnPrimary: btnPrimary ?? this.btnPrimary,
      btnSecondary: btnSecondary ?? this.btnSecondary,
      btnAction: btnAction ?? this.btnAction,
      successGreen: successGreen ?? this.successGreen,
      statusPendenteBg: statusPendenteBg ?? this.statusPendenteBg,
      statusPendenteTxt: statusPendenteTxt ?? this.statusPendenteTxt,
      statusEntregueBg: statusEntregueBg ?? this.statusEntregueBg,
      statusEntregueTxt: statusEntregueTxt ?? this.statusEntregueTxt,
      statusVerificadoBg: statusVerificadoBg ?? this.statusVerificadoBg,
      statusVerificadoTxt: statusVerificadoTxt ?? this.statusVerificadoTxt,
      errorBg: errorBg ?? this.errorBg,
      errorText: errorText ?? this.errorText,
      statGreenBg: statGreenBg ?? this.statGreenBg,
      statGreenOrb: statGreenOrb ?? this.statGreenOrb,
      statGreenTxt: statGreenTxt ?? this.statGreenTxt,
      statYellowBg: statYellowBg ?? this.statYellowBg,
      statYellowOrb: statYellowOrb ?? this.statYellowOrb,
      statYellowTxt: statYellowTxt ?? this.statYellowTxt,
      statPinkBg: statPinkBg ?? this.statPinkBg,
      statPinkOrb: statPinkOrb ?? this.statPinkOrb,
      statPinkTxt: statPinkTxt ?? this.statPinkTxt,
      navBg: navBg ?? this.navBg,
      navBorder: navBorder ?? this.navBorder,
      navFabBg: navFabBg ?? this.navFabBg,
      navActive: navActive ?? this.navActive,
      borderLight: borderLight ?? this.borderLight,
      borderCard: borderCard ?? this.borderCard,
      borderFilter: borderFilter ?? this.borderFilter,
      filterBg: filterBg ?? this.filterBg,
      filterTxt: filterTxt ?? this.filterTxt,
      quickCardBg: quickCardBg ?? this.quickCardBg,
      quickBtnBg: quickBtnBg ?? this.quickBtnBg,
      quickTxt: quickTxt ?? this.quickTxt,
      progressBg: progressBg ?? this.progressBg,
      progressFill: progressFill ?? this.progressFill,
      cadastroAlunoBg: cadastroAlunoBg ?? this.cadastroAlunoBg,
      cadastroProfBg: cadastroProfBg ?? this.cadastroProfBg,
      cadastroAlunoBorder: cadastroAlunoBorder ?? this.cadastroAlunoBorder,
      cadastroProfBorder: cadastroProfBorder ?? this.cadastroProfBorder,
      inputBg: inputBg ?? this.inputBg,
      inputBorder: inputBorder ?? this.inputBorder,
      chartBarColor: chartBarColor ?? this.chartBarColor,
      chartBg: chartBg ?? this.chartBg,
      pieBg: pieBg ?? this.pieBg,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      headerBg: Color.lerp(headerBg, other.headerBg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      scaffoldBg: Color.lerp(scaffoldBg, other.scaffoldBg, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkDark: Color.lerp(inkDark, other.inkDark, t)!,
      subInk: Color.lerp(subInk, other.subInk, t)!,
      subInkLight: Color.lerp(subInkLight, other.subInkLight, t)!,
      cardBeige: Color.lerp(cardBeige, other.cardBeige, t)!,
      cardGreen: Color.lerp(cardGreen, other.cardGreen, t)!,
      cardCream: Color.lerp(cardCream, other.cardCream, t)!,
      beigeBox: Color.lerp(beigeBox, other.beigeBox, t)!,
      btnPrimary: Color.lerp(btnPrimary, other.btnPrimary, t)!,
      btnSecondary: Color.lerp(btnSecondary, other.btnSecondary, t)!,
      btnAction: Color.lerp(btnAction, other.btnAction, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      statusPendenteBg: Color.lerp(statusPendenteBg, other.statusPendenteBg, t)!,
      statusPendenteTxt: Color.lerp(statusPendenteTxt, other.statusPendenteTxt, t)!,
      statusEntregueBg: Color.lerp(statusEntregueBg, other.statusEntregueBg, t)!,
      statusEntregueTxt: Color.lerp(statusEntregueTxt, other.statusEntregueTxt, t)!,
      statusVerificadoBg: Color.lerp(statusVerificadoBg, other.statusVerificadoBg, t)!,
      statusVerificadoTxt: Color.lerp(statusVerificadoTxt, other.statusVerificadoTxt, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
      statGreenBg: Color.lerp(statGreenBg, other.statGreenBg, t)!,
      statGreenOrb: Color.lerp(statGreenOrb, other.statGreenOrb, t)!,
      statGreenTxt: Color.lerp(statGreenTxt, other.statGreenTxt, t)!,
      statYellowBg: Color.lerp(statYellowBg, other.statYellowBg, t)!,
      statYellowOrb: Color.lerp(statYellowOrb, other.statYellowOrb, t)!,
      statYellowTxt: Color.lerp(statYellowTxt, other.statYellowTxt, t)!,
      statPinkBg: Color.lerp(statPinkBg, other.statPinkBg, t)!,
      statPinkOrb: Color.lerp(statPinkOrb, other.statPinkOrb, t)!,
      statPinkTxt: Color.lerp(statPinkTxt, other.statPinkTxt, t)!,
      navBg: Color.lerp(navBg, other.navBg, t)!,
      navBorder: Color.lerp(navBorder, other.navBorder, t)!,
      navFabBg: Color.lerp(navFabBg, other.navFabBg, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      borderCard: Color.lerp(borderCard, other.borderCard, t)!,
      borderFilter: Color.lerp(borderFilter, other.borderFilter, t)!,
      filterBg: Color.lerp(filterBg, other.filterBg, t)!,
      filterTxt: Color.lerp(filterTxt, other.filterTxt, t)!,
      quickCardBg: Color.lerp(quickCardBg, other.quickCardBg, t)!,
      quickBtnBg: Color.lerp(quickBtnBg, other.quickBtnBg, t)!,
      quickTxt: Color.lerp(quickTxt, other.quickTxt, t)!,
      progressBg: Color.lerp(progressBg, other.progressBg, t)!,
      progressFill: Color.lerp(progressFill, other.progressFill, t)!,
      cadastroAlunoBg: Color.lerp(cadastroAlunoBg, other.cadastroAlunoBg, t)!,
      cadastroProfBg: Color.lerp(cadastroProfBg, other.cadastroProfBg, t)!,
      cadastroAlunoBorder: Color.lerp(cadastroAlunoBorder, other.cadastroAlunoBorder, t)!,
      cadastroProfBorder: Color.lerp(cadastroProfBorder, other.cadastroProfBorder, t)!,
      inputBg: Color.lerp(inputBg, other.inputBg, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      chartBarColor: Color.lerp(chartBarColor, other.chartBarColor, t)!,
      chartBg: Color.lerp(chartBg, other.chartBg, t)!,
      pieBg: Color.lerp(pieBg, other.pieBg, t)!,
    );
  }
}
