package io.jone.secureapi.service.implementation;

import io.jone.secureapi.domain.User;
import io.jone.secureapi.dto.UserDTO;
import io.jone.secureapi.dtomapper.UserDTOMapper;
import io.jone.secureapi.repository.UserRepository;
import io.jone.secureapi.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImp implements UserService {
    private final UserRepository<User> userRepository;

    @Override
    public UserDTO createUser(User user) {
        return UserDTOMapper.fromUser(userRepository.create(user));
    }
}
