# README

## Potential Issues or Security Risks

### 1. DDOS/Spam API Requests to Overload the Database
**Issue**: Attackers could spam the API with requests, overloading the system and database.

**Mitigation**:
- Consider implementing authentication between services in the future.
- Set up rate limiting using a load balancer to prevent spam.

### 2. Malicious URL Input
**Issue**: Users could submit malicious or invalid URLs that could compromise your database integrity or expose users to phishing sites.

**Mitigation**:
- I already validate URL input before encoding and decoding using regex. Only valid URLs (with HTTP or HTTPS protocol, or just the domain) should be decoded. The valid URL format is `(http/https)://mydomain/[code]`.
- Use `URI.parse` to safely handle input URLs, ensuring that the domain matches our site.

### 3. Short Code Collision  
**Issue**: If two URLs generate the same short code, it could result in a collision.  

**Mitigation**:  
- Use the **`SecureRandom.urlsafe_base64`** function to generate the short code. With 5 bytes, there are 2^40 possible combinations, making collisions highly unlikely.  
- If the service scales significantly, implement a feature to **automatically increase the number of bytes** used for generating the short code based on the **number of records in the database**.  
- Validate whether the code already exists in the database before saving it.  
- Enforce **unique constraints** at the database level on the `short_code` column.

### 4. Data Storage and Privacy
**Issue**: Storing URLs indefinitely can lead to unnecessary storage usage and possible privacy concerns.

**Mitigation**:
- Add a Time-to-Live (TTL) feature where URLs expire after a certain duration. (Future implementation)
- Add a background job to delete expired URLs.

## Scalability and Future Performance Improvements

### 1. Database Bottlenecks
**Issue**: As the number of URLs grows, database queries for encoding/decoding could slow down.

**Solutions**:
- Use indexes on frequently queried fields like `short_code` and `original_url` to improve lookup speed. (Indexed for `short_code`).
- Implement database partitioning or sharding when the table size becomes very large.
- Cache frequently accessed short URLs using tools like **Redis**.

### 2. High Traffic and Concurrency
**Issue**: Under high traffic, the server may struggle to handle concurrent requests.

**Solutions**:
- Use a background job processor like Sidekiq or Resque to offload heavy tasks, including saving URLs.
- Introduce load balancing with tools like Nginx to distribute traffic across multiple servers.
