import 'package:allergeo/models/places/district_model.dart';
import 'package:allergeo/services/places/district_service.dart';
import 'package:flutter/material.dart';

class DistrictListScreen extends StatefulWidget {
  @override
  _DistrictListScreenState createState() => _DistrictListScreenState();
}

class _DistrictListScreenState extends State<DistrictListScreen> {
  late Future<List<DistrictModel>> futureDistricts;

  @override
  void initState() {
    super.initState();
    futureDistricts = DistrictService().fetchDistricts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("İlçeler Listesi")),
      body: FutureBuilder<List<DistrictModel>>(
        future: futureDistricts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("İlçeler bulunamadı."));
          } else {
            List<DistrictModel> districts = snapshot.data!;
            return ListView.builder(
              itemCount: districts.length,
              itemBuilder: (context, index) {
                DistrictModel district = districts[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.location_city), // Varsayılan şehir simgesi
                  ),
                  title: Text(district.name),
                  subtitle: Text(district.city.toString()),
                  onTap: () {
                    // Şehir detaylarına gitme işlemi buraya eklenebilir
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
