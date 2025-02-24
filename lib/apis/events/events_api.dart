part of affogato.apis;

class AffogatoEventsAPI {}

class AffogatoBindTriggers {
  final String id;

  const AffogatoBindTriggers.onLanguage(String language)
      : id = 'onLanguage:$language';

  const AffogatoBindTriggers.onStartupFinished() : id = 'onStartupFinished';
}
