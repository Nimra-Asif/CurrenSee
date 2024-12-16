import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class RealTimeChart extends StatefulWidget {
  final String baseCurrency;
  final String targetCurrency;

  const RealTimeChart(
      {required this.baseCurrency, required this.targetCurrency});

  @override
  _RealTimeChartState createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {
  List<FlSpot> dataPoints = []; // Points for the chart
  double index = 0; // X-axis index for each data point
  Timer? timer; // Timer for periodic updates
  bool isLoading = true; // Loading indicator
  String? hoverDate; // To store hovered date for tooltip
  String? hoverRate; // To store hovered rate for tooltip

  @override
  void initState() {
    super.initState();
    fetchCurrencyData(); // Initial data fetch
    startPolling(); // Start periodic updates
  }

  @override
  void dispose() {
    timer?.cancel(); // Stop polling when widget is disposed
    super.dispose();
  }

  // Function to start polling for real-time updates
  void startPolling() {
    timer = Timer.periodic(Duration(seconds: 30), (_) => fetchCurrencyData());
  }

  // Fetch currency data from ExchangeRate-Host API
  Future<void> fetchCurrencyData() async {
    try {
      final url =
          "https://api.exchangerate.host/timeframe?access_key=47a9d0f5516dcc5952ed00f3fbd5b9a0&start_date=2024-06-17&end_date=2024-11-17&source=${widget.baseCurrency}";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final quotes = data['quotes'];

          if (quotes != null) {
            quotes.forEach((date, rateData) {
              // Access the target currency rate
              final rate =
                  rateData['${widget.baseCurrency}${widget.targetCurrency}'];
              if (rate != null) {
                setState(() {
                  dataPoints.add(FlSpot(index, rate));
                  index++;
                });
              }
            });

            setState(() {
              isLoading = false;
            });
          } else {
             print("Your free API plan request of this month has been exceeded.Please try again in new month.");
          }
        } else {
          throw Exception("API request not successful");
        }
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.baseCurrency} to ${widget.targetCurrency} Chart"),
        backgroundColor: AppConstant().secondaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 800, // Set custom height for the chart
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false), // Remove the grid
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            DateTime date =
                                DateTime(2024, 11, value.toInt() + 1);
                            String month =
                                "${date.month}-${date.year}"; // Show month and year
                            return Text(
                              month,
                              style: TextStyle(
                                color: AppConstant().secondaryColor,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false, // Remove the border lines
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: dataPoints,
                        isCurved: true,
                        color: AppConstant().secondaryColor,
                        barWidth: 1,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        // tooltipBgColor: Colors.grey.withOpacity(0.7),
                        getTooltipItems: (spots) {
                          return spots.map((LineBarSpot spot) {
                            final date = DateTime(2024, 11, spot.x.toInt() + 1);
                            final formattedDate =
                                "${date.day}-${date.month}-${date.year}";
                            return LineTooltipItem(
                              "$formattedDate: ${spot.y.toStringAsFixed(2)}",
                              TextStyle(color: AppConstant().textColor),
                            );
                          }).toList();
                        },
                      ),
                      // touchCallback: (LineTouchResponse touchResponse) {
                      //   if (touchResponse.lineTouchInput is LineTouchEnd ||
                      //       touchResponse.lineTouchInput is LineTouchStart) {
                      //     setState(() {
                      //       hoverDate = null;
                      //       hoverRate = null;
                      //     });
                      //   }
                      // },
                      handleBuiltInTouches: true,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
