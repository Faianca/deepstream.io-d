module message.constants;

enum ConnectionState {
    CLOSED,
    AWAITING_CONNECTION,
    CHALLENGING,
    AWAITING_AUTHENTICATION,
    AUTHENTICATING,
    OPEN,
    ERROR,
    RECONNECTING
};

enum Topic : string {
    CONNECTION = "C",
    AUTH = "A",
    ERROR = "X",
    EVENT = "E",
    RECORD = "R",
    RPC = "P",
    WEBRTC = "W",
    PRIVATE = "PRIVATE/"
}

enum Actions : string {
    ACK = "A",
    REDIRECT = "RED",
    CHALLENGE = "CH",
    CHALLENGE_RESPONSE = "CHR",
    READ = "T",
    CREATE = "C",
    UPDATE = "U",
    PATCH = "P",
    DELETE = "D",
    SUBSCRIBE = "S",
    UNSUBSCRIBE = "US",
    HAS = "H",
    SNAPSHOT = "SN",
    INVOKE = "I",
    SUBSCRIBTION_FOR_PATTERN_FOUND = "SP",
    SUBSCRIBTION_FOR_PATTERN_REMOVED = "SR",
    LISTEN = "L",
    UNLISTEN = "UL",
    PROVIDER_UPDATE = "PU",
    QUERY = "Q",
    CREATEORREAD = "CR",
    EVENT = "EVT",
    ERROR = "E",
    REQUEST = "REQ",
    RESPONSE = "RES",
    REJECTION = "REJ"
};
