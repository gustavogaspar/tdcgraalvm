
package oracle.tcd;


import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;




@Path("/greetings")
public class GreetResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String getDefaultMessage() {
        return "Hello Helidon";
    }
}
