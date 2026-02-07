import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/domain/services/pdf_generator.dart';

/// Concrete implementation of PdfGenerator using pdf package
class PdfGeneratorImpl implements PdfGenerator {
  @override
  Future<File> generate(ExportReport report) async {
    final pdf = pw.Document();

    // Load Korean font
    final font = await PdfGoogleFonts.notoSansKRRegular();
    final boldFont = await PdfGoogleFonts.notoSansKRBold();

    final theme = pw.ThemeData.withFont(
      base: font,
      bold: boldFont,
    );

    // Add pages
    pdf.addPage(_buildCoverPage(report, theme));
    pdf.addPage(_buildSummaryPage(report, theme));
    pdf.addPage(_buildExpenseListPage(report, theme));
    pdf.addPage(_buildChartsPage(report, theme));
    pdf.addPage(_buildInsightsPage(report, theme));

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'trip_report_${report.trip.id}_$timestamp.pdf';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Page _buildCoverPage(ExportReport report, pw.ThemeData theme) {
    return pw.Page(
      theme: theme,
      build: (context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                '여행 보고서',
                style: pw.TextStyle(
                  fontSize: 48,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                report.trip.title,
                style: const pw.TextStyle(fontSize: 32),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                '${DateFormat('yyyy.MM.dd').format(report.trip.startDate)} - ${DateFormat('yyyy.MM.dd').format(report.trip.endDate)}',
                style: const pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                '생성일: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  pw.Page _buildSummaryPage(ExportReport report, pw.ThemeData theme) {
    final currencyFormat = NumberFormat.currency(
      symbol: report.trip.baseCurrency,
      decimalDigits: 0,
    );

    return pw.Page(
      theme: theme,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '여행 요약',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 30),
              _buildSummaryRow('여행 이름', report.trip.title),
              _buildSummaryRow('기간', '${DateFormat('yyyy.MM.dd').format(report.trip.startDate)} - ${DateFormat('yyyy.MM.dd').format(report.trip.endDate)}'),
              _buildSummaryRow('예산', currencyFormat.format(report.budgetSummary.totalBudget)),
              _buildSummaryRow('총 지출', currencyFormat.format(report.budgetSummary.totalSpent)),
              _buildSummaryRow('잔액', currencyFormat.format(report.budgetSummary.remaining)),
              _buildSummaryRow('예산 사용률', '${report.budgetSummary.percentUsed.toStringAsFixed(1)}%'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              _buildSummaryRow('총 지출 건수', '${report.expenses.length}건'),
              _buildSummaryRow('일평균 지출', currencyFormat.format(report.budgetSummary.dailyAverage)),
            ],
          ),
        );
      },
    );
  }

  pw.Widget _buildSummaryRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 16),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Page _buildExpenseListPage(ExportReport report, pw.ThemeData theme) {
    final currencyFormat = NumberFormat.currency(
      symbol: report.trip.baseCurrency,
      decimalDigits: 0,
    );

    return pw.Page(
      theme: theme,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '지출 내역',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              if (report.expenses.isEmpty)
                pw.Text('지출 내역이 없습니다.')
              else
                pw.Expanded(
                  child: pw.ListView.builder(
                    itemCount: report.expenses.length > 20 ? 20 : report.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = report.expenses[index];
                      return pw.Container(
                        margin: const pw.EdgeInsets.only(bottom: 10),
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey300),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  expense.memo ?? expense.category.labelKo,
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  currencyFormat.format(expense.amount),
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '${DateFormat('yyyy.MM.dd').format(expense.date)} • ${expense.category.labelKo}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if (report.expenses.length > 20)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 10),
                  child: pw.Text(
                    '※ 최근 20건만 표시됩니다.',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  pw.Page _buildChartsPage(ExportReport report, pw.ThemeData theme) {
    return pw.Page(
      theme: theme,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '통계 차트',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                '카테고리별 지출',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              if (report.statistics.categoryTotals.isEmpty)
                pw.Text('카테고리별 통계가 없습니다.')
              else
                ...report.statistics.categoryTotals.entries.map((entry) {
                  final currencyFormat = NumberFormat.currency(
                    symbol: report.trip.baseCurrency,
                    decimalDigits: 0,
                  );
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(entry.key.labelKo),
                        pw.Text(currencyFormat.format(entry.value)),
                      ],
                    ),
                  );
                }),
              pw.SizedBox(height: 20),
              pw.Text(
                '결제수단별 지출',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              if (report.statistics.paymentMethodTotals.isEmpty)
                pw.Text('결제수단별 통계가 없습니다.')
              else
                ...report.statistics.paymentMethodTotals.entries.map((entry) {
                  final currencyFormat = NumberFormat.currency(
                    symbol: report.trip.baseCurrency,
                    decimalDigits: 0,
                  );
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(entry.key),
                        pw.Text(currencyFormat.format(entry.value)),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  pw.Page _buildInsightsPage(ExportReport report, pw.ThemeData theme) {
    return pw.Page(
      theme: theme,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '인사이트',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 30),
              if (report.insights.isEmpty)
                pw.Text('인사이트가 없습니다.')
              else
                ...report.insights.map((insight) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 15),
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          insight.title,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          insight.description,
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
