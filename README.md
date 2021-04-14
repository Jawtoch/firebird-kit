# FirebirdKit

Provide helpers to use FirebirdNIO.

## Data conversion

To use types such as String, Date, Bool, Double, Int, ... as binds in [FirebirdNIO](https://github.com/Jawtoch/firebird-nio) or [Firebird](https://github.com/Jawtoch/firebird-lib), theses types conforms to `FirebirdCodable`

```swift
public typealias FirebirdCodable = FirebirdEncodable & FirebirdDecodable

public protocol FirebirdEncodable: Encodable {
		
	/// FirebirdData associated to this value
	static var firebirdDataType: FirebirdDataType { get }
	
	var firebirdData: FirebirdData { get }
}


public protocol FirebirdDecodable: Decodable {
	
	init?(from firebirdData: FirebirdData) throws
	
}
```

You can use your own types as binds by conforming to `FirebirdCodable`.

## SQL query

The `FirebirdSQLDatabase` struct wrap a `FirebirdNIODatabase`. To pass a sql query, see `SQLDatabase` documentation.
