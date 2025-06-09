import 'package:aquiles/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 24),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A1128),
                  const Color(0xFF295B62),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF3F797A).withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8CCBD5).withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF3F797A),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Juan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text("Paciente"),
                const SizedBox(height: 24),
                const Divider(
                  color: Color(0xFF3F797A),
                  thickness: 1,
                ),
                const SizedBox(height: 24),
                const Text('Información Personal',
                    style: TextStyle(
                      color: Color(0xFFFFFFFA),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.email, 'juan.perez@example.com'),
                _buildInfoRow(Icons.phone, '+54 9 11 1234-5678'),
                _buildInfoRow(Icons.location_on, 'Av. Siempre Viva 742'),
                const SizedBox(height: 24),
                const Divider(
                  color: Color(0xFF3F797A),
                  thickness: 1,
                ),
                const SizedBox(height: 24),
                const Text('Información Médica',
                    style: TextStyle(
                      color: Color(0xFFFFFFFA),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.medical_services, 'OSDE 210'),
                _buildInfoRow(
                    Icons.warning_amber_rounded, 'Paciente en rehabilitacion '),
                _buildInfoRow(Icons.medical_information,
                    'Medico a cargo: Dr. Juan Perez'),
                _buildInfoRow(
                    Icons.calendar_month, 'Ultima consulta: 26/05/2025'),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    ref.read(authServiceProvider).signOut();
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    "Cerrar sesion",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8CCBD5), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFFFFFFA), fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
