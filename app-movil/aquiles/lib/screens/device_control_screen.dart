import 'package:flutter/material.dart';

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({Key? key}) : super(key: key);

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  double _assistiveResponsiveness = 50;
  double _hdcGain = 50;
  double _brightness = 50;
  bool _hillDescentControl = true;
  bool _adaptiveMotion = true;
  String _selectedMode = 'ECO';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control del Dispositivo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDevicePreview(),
              const SizedBox(height: 24),
              Text(
                'Modos de Operación',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildModeSelector(),
              const SizedBox(height: 24),
              Text(
                'Personalizar MotionEngine',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildSettingSlider(
                label: 'Asistencia Responsiva',
                description:
                    'Ajusta la velocidad de respuesta para la sincronización humano-máquina',
                value: _assistiveResponsiveness,
                onChanged: (value) {
                  setState(() {
                    _assistiveResponsiveness = value;
                  });
                },
                minLabel: 'Lento',
                maxLabel: 'Rápido',
              ),
              const SizedBox(height: 16),
              _buildSettingSwitch(
                label: 'Control de descenso en pendiente (HDC)',
                description:
                    'La función HDC asegura estabilidad y seguridad en pendientes',
                value: _hillDescentControl,
                onChanged: (value) {
                  setState(() {
                    _hillDescentControl = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSettingSlider(
                label: 'Ajuste de ganancia HDC',
                description:
                    'Ajusta la intensidad de frenado para descensos suaves',
                value: _hdcGain,
                onChanged: (value) {
                  setState(() {
                    _hdcGain = value;
                  });
                },
                minLabel: 'Débil',
                maxLabel: 'Fuerte',
              ),
              const SizedBox(height: 16),
              _buildSettingSwitch(
                label: 'Reconocimiento de Movimiento Adaptativo',
                description: 'Desactiva para seleccionar manualmente',
                value: _adaptiveMotion,
                onChanged: (value) {
                  setState(() {
                    _adaptiveMotion = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSettingSlider(
                label: 'Ajuste de Brillo',
                description: 'Ajusta el brillo de los LEDs en el dispositivo',
                value: _brightness,
                onChanged: (value) {
                  setState(() {
                    _brightness = value;
                  });
                },
                minLabel: 'Oscuro',
                maxLabel: 'Brillante',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('GUARDAR CONFIGURACIÓN'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                ),
                child: const Text('RESTABLECER VALORES PREDETERMINADOS'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevicePreview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 200,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDeviceStatusChip(
                  label: 'Batería',
                  value: '96%',
                  color: Colors.green,
                ),
                _buildDeviceStatusChip(
                  label: 'Modo',
                  value: _selectedMode,
                  color: const Color(0xFF8DD3D7),
                ),
                _buildDeviceStatusChip(
                  label: 'Estado',
                  value: 'Listo',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceStatusChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: [
        _buildModeButton(
          label: 'ECO',
          isSelected: _selectedMode == 'ECO',
          onTap: () {
            setState(() {
              _selectedMode = 'ECO';
            });
          },
        ),
        const SizedBox(width: 12),
        _buildModeButton(
          label: 'NORMAL',
          isSelected: _selectedMode == 'NORMAL',
          onTap: () {
            setState(() {
              _selectedMode = 'NORMAL';
            });
          },
        ),
        const SizedBox(width: 12),
        _buildModeButton(
          label: 'SPORT',
          isSelected: _selectedMode == 'SPORT',
          onTap: () {
            setState(() {
              _selectedMode = 'SPORT';
            });
          },
        ),
        const SizedBox(width: 12),
        _buildModeButton(
          label: 'TRANSPARENTE',
          isSelected: _selectedMode == 'TRANSPARENTE',
          onTap: () {
            setState(() {
              _selectedMode = 'TRANSPARENTE';
            });
          },
        ),
      ],
    );
  }

  Widget _buildModeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8DD3D7) : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSlider({
    required String label,
    required String description,
    required double value,
    required ValueChanged<double> onChanged,
    required String minLabel,
    required String maxLabel,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  minLabel,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    activeColor: const Color(0xFF8DD3D7),
                    inactiveColor: Colors.grey[300],
                    onChanged: onChanged,
                  ),
                ),
                Text(
                  maxLabel,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value ? 'Activado' : 'Desactivado',
                    style: TextStyle(
                      color: value ? const Color(0xFF8DD3D7) : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: value,
                  activeColor: const Color(0xFF8DD3D7),
                  onChanged: onChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
