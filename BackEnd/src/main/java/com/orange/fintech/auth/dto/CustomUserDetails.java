package com.orange.fintech.auth.dto;

import com.orange.fintech.member.entity.Member;
import java.util.ArrayList;
import java.util.Collection;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Slf4j
@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {

    private final Member member;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {

        Collection<GrantedAuthority> collection = new ArrayList<>();

        collection.add(
                new GrantedAuthority() {

                    @Override
                    public String getAuthority() {

                        return member.getRole().toString();
                    }
                });

        return collection;
    }

    @Override
    public String getPassword() {

        return "null";
    }

    @Override
    public String getUsername() {
        //        log.info("member : {} ", member.toString());
        //        log.info("** getUsername 실행");
        return member.getKakaoId();
    }

    @Override
    public boolean isAccountNonExpired() {

        return true;
    }

    @Override
    public boolean isAccountNonLocked() {

        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {

        return true;
    }

    @Override
    public boolean isEnabled() {

        return true;
    }
}
