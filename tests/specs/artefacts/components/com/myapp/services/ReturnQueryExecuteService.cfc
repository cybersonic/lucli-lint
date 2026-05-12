/**
 * Fixture for queryExecute calls returned directly from a function.
 */
component {

    public query function getUsers() {
        return queryExecute(
            sql: "
                SELECT id
                FROM users
            "
        );
    }
}
