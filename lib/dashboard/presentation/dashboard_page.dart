import 'package:bot_toast/bot_toast.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/dashboard/presentation/cubit/relatorio_cubit.dart';
import 'package:gestor_vendas/dashboard/presentation/cubit/relatorio_state.dart';
import 'package:gestor_vendas/util/calendario_horizontal.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../widget/header_widget.dart';
import '../../widget/side_bar.dart';

class RelatorioScreen extends StatefulWidget {
  @override
  _RelatorioPageState createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioScreen> {
  late RelatorioCubit _cubit;

  static const String route = '/dashboard';
  late TooltipBehavior _tooltipBehavior;
  String? mesSelected;
  String? prodMesSelected;

  var selectedDate = DateTime.now();
  @override
  void initState() {
    _cubit = RelatorioCubit(context);
    _cubit.load();
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<RelatorioCubit, RelatorioState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.primaryColor,
            body: Column(
              children: [
                HeaderWidget(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SideBar(),
                      Flexible(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dashboard',
                                            style: theme.textTheme.bodyText1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Card(
                                    elevation: 0,
                                    color: Colors.grey[50],
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Center(
                                            child: Text('Vendas por dia', style: theme.textTheme.headline4),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: HorizontalWeekCalendar(
                                                  weekStartFrom: WeekStartFrom.Monday,
                                                  activeBackgroundColor: Colors.green,
                                                  activeTextColor: Colors.white,
                                                  inactiveBackgroundColor: Colors.blue.withOpacity(.3),
                                                  inactiveTextColor: Colors.white,
                                                  disabledTextColor: Colors.grey,
                                                  disabledBackgroundColor: Colors.grey.withOpacity(.3),
                                                  activeNavigatorColor: Colors.blue,
                                                  inactiveNavigatorColor: Colors.grey,
                                                  monthColor: Colors.blue,
                                                  onDateChange: (date) {
                                                    setState(() {
                                                      selectedDate = date;
                                                    });

                                                    _cubit.vendaPorStatusPedidos(selectedDate);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Card(
                                                color: Colors.orange[500],
                                                elevation: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(30.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Em andamento', style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                      SizedBox(height: 15),
                                                      Text(_cubit.listaNovosPedidos.length.toString(), style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                      SizedBox(height: 15),
                                                      Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.totalVendaNovosPedidos),
                                                          style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                color: Color.fromARGB(255, 26, 129, 155),
                                                elevation: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(30.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Finalizados', style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                      SizedBox(height: 15),
                                                      Text(_cubit.listaFinalizados.length.toString(), style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                      SizedBox(height: 15),
                                                      Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.totalVendaFinalizados),
                                                          style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                color: const Color.fromARGB(255, 242, 72, 89),
                                                elevation: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(30.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Cancelados', style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                      SizedBox(height: 15),
                                                      Text(_cubit.listaCancelados.length.toString(), style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                      SizedBox(height: 15),
                                                      Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.totalVendaCancelada),
                                                          style: theme.textTheme.displayMedium!.copyWith(color: Colors.white)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Card(
                                    elevation: 0,
                                    color: Colors.grey[50],
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SfCartesianChart(
                                          primaryXAxis: CategoryAxis(),
                                          title: ChartTitle(text: 'Vendas ${DateTime.now().year}', textStyle: theme.textTheme.headline4!),
                                          legend: Legend(isVisible: false),
                                          tooltipBehavior: _tooltipBehavior,
                                          series: <ChartSeries<SalesData, String>>[
                                            LineSeries<SalesData, String>(
                                                dataSource: _cubit.datas,
                                                xValueMapper: (SalesData sales, _) => sales.month,
                                                yValueMapper: (SalesData sales, _) => sales.sales,
                                                name: 'Vendas',
                                                // Enable data label
                                                dataLabelSettings: DataLabelSettings(isVisible: true))
                                          ]),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.grey[50],
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 300,
                                                  child: DropdownButtonFormField<String>(
                                                    decoration: InputDecoration(
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        filled: true,
                                                        hintText: "Todos meses",
                                                        hintStyle: theme.textTheme.bodyText2!.copyWith(color: Colors.black)
                                                        // fillColor: Colors.grey[300],
                                                        ),
                                                    dropdownColor: Colors.white,
                                                    value: mesSelected,
                                                    items: _cubit.datasComVenda.map((SalesData e) {
                                                      return DropdownMenuItem<String>(value: e.month, child: Text(e.month));
                                                    }).toList(),
                                                    onChanged: (String? newValue) {
                                                      mesSelected = newValue;
                                                      _cubit.filtroVendasMes(mesSelected!);
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Center(
                                                  child: Text('Total de Vendas', style: theme.textTheme.headline4!),
                                                ),
                                                SizedBox(height: 40),
                                                // Card(
                                                //   color: Colors.green[100],
                                                //   elevation: 1,
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.all(12.0),
                                                //     child: Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         Text('Vendas', style: theme.textTheme.bodyText1),
                                                //         Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.totalVenda), style: theme.textTheme.headline4!),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                // SizedBox(height: 10),
                                                // Card(
                                                //   color: Colors.green[200],
                                                //   elevation: 1,
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.all(12.0),
                                                //     child: Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         Text('Taxa de entregas', style: theme.textTheme.bodyText1),
                                                //         Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.totalTaxaEntrega), style: theme.textTheme.headline4!),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                SizedBox(height: 10),
                                                Card(
                                                  color: Colors.green[300],
                                                  elevation: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('Total', style: theme.textTheme.bodyText1),
                                                        Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.totalTaxaEntrega + _cubit.totalVenda), style: theme.textTheme.headline4!),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 40),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.grey[50],
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              SizedBox(
                                                width: 300,
                                                child: DropdownButtonFormField<String>(
                                                  decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      filled: true,
                                                      hintText: "Todos meses",
                                                      hintStyle: theme.textTheme.bodyText2!.copyWith(color: Colors.black)
                                                      // fillColor: Colors.grey[300],
                                                      ),
                                                  dropdownColor: Colors.white,
                                                  value: prodMesSelected,
                                                  items: _cubit.datasComVenda.map((SalesData e) {
                                                    return DropdownMenuItem<String>(value: e.month, child: Text(e.month));
                                                  }).toList(),
                                                  onChanged: (String? newValue) {
                                                    prodMesSelected = newValue;
                                                    _cubit.listaProdutosMaisVendidos(mes: prodMesSelected!);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              SfCircularChart(
                                                margin: EdgeInsets.zero,
                                                title: ChartTitle(text: 'Produtos mais vendidos', textStyle: theme.textTheme.headline4!),
                                                legend: Legend(isVisible: true),
                                                series: <PieSeries<PieDataProduto, String>>[
                                                  PieSeries<PieDataProduto, String>(
                                                      explode: true,
                                                      explodeIndex: null,
                                                      dataSource: _cubit.listaPieDataProduto.take(10).toList(),
                                                      xValueMapper: (PieDataProduto data, _) => data.nome,
                                                      yValueMapper: (PieDataProduto data, _) => data.quantidade,
                                                      dataLabelMapper: (PieDataProduto data, _) => data.quantidade.toString(),
                                                      dataLabelSettings: DataLabelSettings(isVisible: true)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
