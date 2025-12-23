// lib/constants/app_constants.dart

class AppConstants {
  static const String VERSION = '1.0';
  static const String RESPONSE = 'response';
  static const String METADATA = 'documentsMetaData';
  static const String ERROR = 'error';
  static const String NESTED_ERROR = 'errors';
  static const String ERROR_CODE = 'errorCode';
  static const String API_ERROR_CODES = 'API_ERROR_CODES';
  static const String DIALOG = 'dialog';
  static const String PRE_REGISTRATION_ID = 'pre_registration_id';
  static const String APPENDER = '/';
  static const String IDSchemaVersionLabel = 'IDSchemaVersion';

  static const Map<String, String> IDS = {
    'newUser': 'mosip.pre-registration.demographic.create',
    'updateUser': 'mosip.pre-registration.demographic.update',
    'transliteration': 'mosip.pre-registration.transliteration.transliterate',
    'notification': 'mosip.pre-registration.notification.notify',
    'cancelAppointment': 'mosip.pre-registration.appointment.cancel',
    'booking': 'mosip.pre-registration.booking.book',
    'qrCode': 'mosip.pre-registration.qrcode.generate',
    'sendOtp': 'mosip.pre-registration.login.sendotp',
    'validateOtp': 'mosip.pre-registration.login.useridotp',
    'documentUpload': 'mosip.pre-registration.document.upload',
    'applicantTypeId': 'mosip.applicanttype.fetch',
    'captchaId': 'mosip.pre-registration.captcha.id.validate',
  };

  static const Map<String, String> APPEND_URL = {
    'config': 'config',
    'send_otp': 'sendOtp',
    'login': 'validateOtp',
    'logout': 'invalidateToken',
    'location_metadata': 'locations/locationhierarchy/',
    'location_immediate_children': 'locations/immediatechildren/',
    'applicants': 'applications/prereg',
    'location': '/masterdata/',
    'gender': '/masterdata/gendertypes',
    'resident': '/masterdata/individualtypes',
    'transliteration': 'transliteration/transliterate',
    // 'applicantType': 'v1/applicanttype/',
    'applicantType': '/masterdata/',
    'validDocument': 'applicanttype/',
    'getApplicantType': 'getApplicantType',
    'post_document': 'documents/',
    'document': 'documents/preregistration/',
    'updateDocRefId': 'documents/document/',
    'document_copy': 'document/documents/copy',
    'nearby_registration_centers': 'getcoordinatespecificregistrationcenters/',
    'registration_centers_by_name': 'registrationcenters/',
    'booking_appointment': 'applications/appointment',
    'booking_availability': 'applications/appointment/slots/availability/',
    'delete_application': 'applications/prereg/',
    'qr_code': 'qrCode/generate',
    'notification': 'notification',
    'send_notification': 'notification/notify',
    'master_data': '/masterdata/',
    'auth': 'login/',
    'cancelAppointment': 'applications/appointment/',
    'captcha': 'captcha/validatecaptcha',
  };

  static const Map<String, String> PARAMS_KEYS = {
    'getUsers': 'user_id',
    'getUser': PRE_REGISTRATION_ID,
    'deleteUser': PRE_REGISTRATION_ID,
    'locationHierarchyName': 'hierarchyName',
    'getDocument': PRE_REGISTRATION_ID,
    'getDocumentCategories': 'languages',
    'preRegistrationId': 'preRegistrationId',
    'deleteFile': 'documentId',
    'getAvailabilityData': 'registration_center_id',
    'catCode': 'catCode',
    'sourcePrId': 'sourcePrId',
    'POA': 'POA',
    'docRefId': 'refNumber',
  };

  static const Map<String, String> ERROR_CODES = {
    'noApplicantEnrolled': 'PRG_PAM_APP_005',
    'noLocationAvailable': 'KER-MSD-026',
    'userBlocked': 'PRG_PAM_LGN_013',
    'invalidPin': 'KER-IOV-004',
    'tokenExpired': 'KER-ATH-401',
    'authenticationFailed': 'KER-401',
    'invalidateToken': 'PRG_PAM_LGN_003',
    'slotNotAvailable': 'PRG_BOOK_RCI_002',
    'timeExpired': 'PRG_BOOK_RCI_026',
  };

  static const Map<String, String> CONFIG_KEYS = {
    'mosip_notification_type': 'mosip.notificationtype',
    'mosip_default_location': 'mosip.kernel.idobjectvalidator.masterdata.locations.locationNotAvailable',
    'mosip_country_code': 'mosip.country.code',
    'preregistration_nearby_centers': 'preregistration.nearby.centers',
    'preregistration_timespan_rebook': 'preregistration.timespan.rebook',
    'mosip_login_mode': 'mosip.login.mode',
    'preregistration_identity_name': 'preregistration.identity.name',
    'mosip_regex_email': 'mosip.id.validation.identity.email',
    'mosip_regex_phone': 'mosip.id.validation.identity.phone',
    'mosip_left_to_right_orientation': 'mosip.left_to_right_orientation',
    'mosip_kernel_otp_expiry_time': 'mosip.kernel.otp.expiry-time',
    'mosip_kernel_otp_default_length': 'mosip.kernel.otp.default-length',
    'preregistration_recommended_centers_locCode': 'preregistration.recommended.centers.locCode',
    'preregistration_availability_noOfDays': 'preregistration.availability.noOfDays',
    'mosip_regex_referenceIdentityNumber': 'mosip.id.validation.identity.referenceIdentityNumber',
    'mosip_regex_postalCode': 'mosip.id.validation.identity.postalCode',
    'mosip_regex_DOB': 'mosip.id.validation.identity.dateOfBirth',
    'mosip_default_dob_day': 'mosip.default.dob.day',
    'mosip_default_dob_month': 'mosip.default.dob.month',
    'preregistration_address_length': 'mosip.id.validation.identity.addressLine1.[*].value',
    'preregistration_fullname_length': 'mosip.id.validation.identity.fullName.[*].value',
    'mosip_id_validation_identity_age': 'mosip.id.validation.identity.age',
    'mosip_preregistration_auto_logout_idle': 'mosip.preregistration.auto.logout.idle',
    'mosip_preregistration_auto_logout_timeout': 'mosip.preregistration.auto.logout.timeout',
    'mosip_preregistration_auto_logout_ping': 'mosip.preregistration.auto.logout.ping',
    'preregistration_document_alllowe_files': 'preregistration.documentupload.allowed.file.type',
    'preregistration_document_alllowe_file_size': 'preregistration.documentupload.allowed.file.size',
    'preregistration_document_alllowe_file_name_lenght': 'preregistration.documentupload.allowed.file.nameLength',
    'google_recaptcha_site_key': 'google.recaptcha.site.key',
    'mosip_adult_age': 'mosip.adult.age',
    'preregistration_preview_fields': 'preregistration.preview.fields',
    'mosip_mandatory_languages': 'mosip.mandatory-languages',
    'mosip_optional_languages': 'mosip.optional-languages',
    'mosip_min_languages_count': 'mosip.min-languages.count',
    'mosip_max_languages_count': 'mosip.max-languages.count',
    'preregistration_contact_email': 'preregistration.contact.email',
    'preregistration_contact_phone': 'preregistration.contact.phone',
  };

  static const Map<String, Map<String, String>> DASHBOARD_RESPONSE_KEYS = {
    'bookingRegistrationDTO': {
      'dto': 'bookingMetadata',
      'regDate': 'appointment_date',
      'time_slot_from': 'time_slot_from',
      'time_slot_to': 'time_slot_to',
    },
    'applicant': {
      'preId': 'preRegistrationId',
      'fullname': 'fullName',
      'statusCode': 'statusCode',
      'postalCode': 'postalCode',
      'basicDetails': 'basicDetails',
      'demographicMetadata': 'demographicMetadata',
    },
  };

  static const Map<String, String> DEMOGRAPHIC_RESPONSE_KEYS = {
    'locations': 'locations',
    'preRegistrationId': 'preRegistrationId',
    'genderTypes': 'genderType',
    'residentTypes': 'individualTypes',
  };

  static const Map<String, String> APPLICATION_STATUS_CODES = {
    'incomplete': 'Application_Incomplete',
    'pending': 'Pending_Appointment',
    'prefetched': 'Prefetched',
    'booked': 'Booked',
    'expired': 'Expired',
    'cancelled': 'Cancelled',
  };

  static const Map<String, String> APPLICANT_TYPE_ATTRIBUTES = {
    'biometricAvailable': 'biometricAvailable',
  };

  static const Map<String, String> notificationDtoKeys = {
    'notificationDto': 'NotificationRequestDTO',
    'langCode': 'langCode',
    'file': 'attachment',
  };

  static const String DOCUMENT_UPLOAD_REQUEST_DOCUMENT_KEY = 'file';
  static const String DOCUMENT_UPLOAD_REQUEST_DTO_KEY = 'Document request';

  static const String PREVIEW_DATA_APPEND_URL = 'demographic/v0.1/applicationData';

  static const List<String> MONTHS = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const String controlTypeGender = 'gender';
  static const String controlTypeResidenceStatus = 'residenceStatus';

  static const String DATA_CAPTURE_LANGUAGES = "dataCaptureLanguages";
  static const String DATA_CAPTURE_LANGUAGE_LABELS = "dataCaptureLanguagesLabels";
  static const String LANGUAGE_CODE_VALUES = "languageCodeValue";
  static const String MODIFY_USER = "modifyUser";
  static const String NEW_APPLICANT = "newApplicant";
  static const String MODIFY_USER_FROM_PREVIEW = "modifyUserFromPreview";
  static const String NEW_APPLICANT_FROM_PREVIEW = "addingUserFromPreview";

  static const String FORCE_LOGOUT = "forceLogout";
  static const String FORCE_LOGOUT_YES = "yes";

  static const String FIELD_TYPE_STRING = "string";
  static const String FIELD_TYPE_SIMPLE_TYPE = "simpleType";
}