package io.jone.secureapi.service;

import io.jone.secureapi.domain.User;
import io.jone.secureapi.dto.UserDTO;

public interface UserService {
    UserDTO createUser(User user);
}
