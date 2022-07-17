import Firebird

public enum FirebirdDataConvertionError: FirebirdError {
	case typeMismatch
	case dataRequired
}
