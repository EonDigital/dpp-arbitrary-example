// For writing to console
#include <ostream>
// For accessing the headers
#include <map>
// We use strings in our operators
#include <string>
// We also use pairs
#include <utility>
// Discord bot support
#include <dpp/dpp.h>

// We're not actually using a bot here, so just skip this part.
const char BOT_TOKEN[] = "";

// Simple way to print the contents of a map
std::ostream & operator<<( std::ostream & stream, const std::map<std::string, std::string> map ) {
    stream << "Map Contents: " << std::endl;
    for( auto & pair : map ) {
        stream << "(" << pair.first << "=>" << pair.second << ")" << std::endl;
    }
    return stream;
}

// Same technique, applied to multimaps (works identically)
std::ostream & operator<<( std::ostream & stream, const std::multimap<std::string, std::string> map ) {
    stream << "MultiMap Contents: " << std::endl;
    for( auto & pair : map ) {
        stream << "(" << pair.first << "=>" << pair.second << ")" << std::endl;
    }
    return stream;
}

int main( int argc, char ** argv ) {

    // First, we show the difference in behavior between a map and multimap
    std::map<std::string, std::string> example1;
    std::multimap<std::string, std::string> example2;
    example1.emplace( "a", "hello" );
    example1.emplace( "a", "world" );
    example2.emplace( "a", "hello" );
    example2.emplace( "a", "world" );
    std::cout << example1 << std::endl;
    std::cout << example2 << std::endl;

    const char * USED_BOT_TOKEN = ( argc > 1 ) ? argv[1] : BOT_TOKEN;

    dpp::cluster bot(USED_BOT_TOKEN, dpp::i_default_intents);
    bot.on_log(dpp::utility::cout_logger());

    bot.on_ready( [&bot]( const dpp::ready_t & event ) {
        // Testing out arbitrary access before starting the bot...
        // Google will attempt to set multiple cookies when accessed
        bot.request(
            "https://www.mediawiki.org/wiki/api.php",
            dpp::m_get,
            [&bot]( const dpp::http_request_completion_t & cc ) {
            std::cout << "Get Reply: " << cc.body
                      << " with status: " << cc.status
                      << " and headers: " << cc.headers
                      << std::endl;
        });

    });


    // Don't even start the bot for now.
    try {
        bot.start(dpp::st_wait);
    } catch ( const dpp::invalid_token_exception & e ) {
        std::cout << "You can provide a token as the first argument for this bot." << std::endl;
        std::cout << "Failed" << std::endl;
        return 1;
    }

    std::cout << "Completed" << std::endl;
    return 0;
}
