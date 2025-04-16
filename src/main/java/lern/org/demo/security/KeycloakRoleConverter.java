package lern.org.demo.security;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.*;
import java.util.stream.Collectors;


import static java.util.Collections.emptyList;
import static java.util.Collections.emptyMap;

public class KeycloakRoleConverter implements Converter<Jwt, Collection<GrantedAuthority>> {
    @Override
    public Collection<GrantedAuthority> convert(final Jwt jwt) {
        final Map<String, Object> claims = jwt.getClaims();
        final Map<String, Map<String, List<String>>> resourceAccess =
                (Map<String, Map<String, List<String>>>) claims.getOrDefault("resource_access", emptyMap());
        Map<String, List<String>> backendRoles = resourceAccess.getOrDefault("spring-boot-rest", emptyMap());
        return backendRoles.getOrDefault("roles", emptyList()).stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toList());
    }

//    private Collection<? extends GrantedAuthority> extractRoles(final Jwt jwt) {
//        return Optional.ofNullable(
//                        jwt.getClaimAsMap("resource_access")
//                )
//                .map(resourceAccess -> resourceAccess.get("client-id"))
//                .map(Map.class::cast)
//                .map(client -> client.get("roles"))
//                .map(Collection.class::cast)
//                .map(roles -> ((Collection<String>) roles).stream()
//                        .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
//                        .collect(Collectors.toSet())
//                ).orElse(Collections.emptySet());
//
//    }
}
