import 'dart:developer';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keeptrack_flutter/expenses/models/summary_per_month.model.dart';
import 'package:keeptrack_flutter/expenses/cubit/expenses_cubit.dart';
import 'package:keeptrack_flutter/expenses/models/expense.model.dart';

class Chart extends StatelessWidget {
  final List<ExpenseCategory> selectedCategories;

  const Chart({Key? key, required this.selectedCategories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: BlocBuilder<ExpensesCubit, ExpensesState>(
        builder: (context, state) {
          print(state);
          if (state is ExpensesLoaded) {
            inspect(state.summaries);
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 24),
              child: _chart(selectedCategories, state.summaries),
            );
          }

          if (state is ExpensesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _chart(List<ExpenseCategory> selectedCategories, List<SummaryPerMonth> summaries) {
    num amountOfNumbers = calculateHeighestValue(summaries).toInt().toString().length;
    return AspectRatio(
      aspectRatio: 3,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: amountOfNumbers == 1
                    ? 10
                    : amountOfNumbers == 2
                        ? 25
                        : amountOfNumbers == 3
                            ? 30
                            : amountOfNumbers == 4
                                ? 40
                                : 50,
                getTitlesWidget: ((value, meta) => leftTitles(value, meta, summaries)),
              ),
            ),
            rightTitles: AxisTitles(),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 30,
              ),
            ),
          ),
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: [
            if (selectedCategories.isEmpty)
              for (var i = 0; i < ExpenseCategory.values.length; i++)
                generateGroupData(i, [
                  chooseRange(
                    summaries,
                    ExpenseCategory.values[i],
                    2022,
                    9,
                  )
                ], [
                  ExpenseCategory.values[i]
                ]),
            if (selectedCategories.isNotEmpty)
              for (var i = 0; i < DateTime.monthsPerYear; i++)
                generateGroupData(
                  i,
                  [
                    for (final category in selectedCategories)
                      chooseRange(
                        summaries,
                        category,
                        2022,
                        i + 1,
                      )
                  ],
                  selectedCategories,
                )
          ],
          maxY: calculateHeighestValue(summaries),
        ),
      ),
    );
  }

  double calculateHeighestValue(List<SummaryPerMonth> summaries) {
    if (summaries.isNotEmpty) {
      return summaries.map((e) => e.amount.abs()).reduce(max).ceil().toDouble();
    } else {
      return 0;
    }
  }

  double chooseRange(
    List<SummaryPerMonth> summaries,
    ExpenseCategory category,
    int year,
    int month,
  ) {
    if (summaries.isNotEmpty) {
      List<SummaryPerMonth> filteredSummaries = summaries
          .where(
            (element) => (element.category == category &&
                element.date.year == year &&
                element.date.month == month),
          )
          .toList();
      if (filteredSummaries.isNotEmpty) {
        return filteredSummaries.first.amount;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  BarChartGroupData generateGroupData(
    int x,
    List<double> uitgaven,
    List<ExpenseCategory> categories,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        for (var i = 0; i < uitgaven.length; i++)
          BarChartRodData(
            fromY: 0,
            toY: uitgaven[i].abs(),
            color: categories[i].color, // TODO: color based on x OR i
            width: 8,
          ),
      ],
    );
  }

  Widget leftTitles(double value, TitleMeta meta, List<SummaryPerMonth> summaries) {
    double angle;
    TextStyle style;
    String text = '';

    style = const TextStyle(fontSize: 10);
    angle = 0;

    switch (value.toInt()) {
      default:
        text = value.toInt().toString();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: angle,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    double angle;
    TextStyle style;
    String text = '';

    if (selectedCategories.isEmpty) {
      style = const TextStyle(fontSize: 10);
      angle = 0.5 * pi;

      // for (var i = 0; i < ExpenseCategory.values.length; i++) {
      //   if (value.toInt() == i) {
      //     text = ExpenseCategory.values[i].name;
      //   }
      // }
    } else {
      style = const TextStyle(fontSize: 10);
      angle = 0;

      DateTime date = DateTime(DateTime.now().year, value.toInt() + 1);
      switch (value.toInt()) {
        default:
          text = DateFormat(DateFormat.ABBR_MONTH).format(date);
      }
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: angle,
      child: Column(children: [Text(text, style: style)]),
    );
  }
}
