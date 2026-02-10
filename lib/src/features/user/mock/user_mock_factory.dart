import 'package:nortus/src/features/user/data/models/user_address_model.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

class UserMockFactory {
  static UserModel createMockUser() {
    return UserModel(
      id: 1,
      name: 'Pedro Silva',
      email: 'pedrosilva@gmail.com',
      language: 'pt-BR',
      dateFormat: 'DD/MM/YYYY',
      timezone: 'America/Sao_Paulo',
      address: UserAddressModel(
        zipCode: '50781-000',
        country: 'Brasil',
        street: 'Avenida São João Domingues Terceiro',
        number: '418',
        complement: 'Casa de número 412, Em frente ao supermercado',
        neighborhood: 'Clássico',
        city: 'São Paulo',
        state: 'SP',
      ),
      updatedAt: DateTime(2025, 11, 5, 10, 30, 0),
    );
  }
}
