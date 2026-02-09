String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Agora há pouco';
  }

  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '$minutes ${minutes == 1 ? 'minuto' : 'minutos'} atrás';
  }

  if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '$hours ${hours == 1 ? 'hora' : 'horas'} atrás';
  }

  if (difference.inDays < 7) {
    final days = difference.inDays;
    return '$days ${days == 1 ? 'dia' : 'dias'} atrás';
  }

  if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'semana' : 'semanas'} atrás';
  }

  if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'mês' : 'meses'} atrás';
  }

  final years = (difference.inDays / 365).floor();
  return '$years ${years == 1 ? 'ano' : 'anos'} atrás';
}
