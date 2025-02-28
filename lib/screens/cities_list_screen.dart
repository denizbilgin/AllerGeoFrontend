import 'package:allergeo/models/places/city_model.dart';
import 'package:allergeo/services/places/city_service.dart';
import 'package:flutter/material.dart';

class CitiesListScreen extends StatefulWidget {
  @override
  _CitiesListScreenState createState() => _CitiesListScreenState();
}

class _CitiesListScreenState extends State<CitiesListScreen> {
  late Future<List<CityModel>> futureCities;

  @override
  void initState() {
    super.initState();
    futureCities = CityService().fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Şehirler Listesi")),
      body: FutureBuilder<List<CityModel>>(
        future: futureCities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Şehirler bulunamadı."));
          } else {
            List<CityModel> cities = snapshot.data!;
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                CityModel city = cities[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.location_city), // Varsayılan şehir simgesi
                  ),
                  title: Text(city.name),
                  subtitle: Text("ID: ${city.id}"),
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
