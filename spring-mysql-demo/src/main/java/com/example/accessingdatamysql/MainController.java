package com.example.accessingdatamysql;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@RestController
public class MainController {

	@Autowired
	private UserRepository userRepository;

	@PostMapping(path="/add")
	public @ResponseBody String addNewUser (@RequestParam String locationName,
											@RequestParam Double latitude,
											@RequestParam Double longitude) {

		Location newLocation = new Location();
		newLocation.setLocationName(locationName);
		newLocation.setLatitude(new BigDecimal(latitude));
		newLocation.setLongitude(new BigDecimal(longitude));

		userRepository.save(newLocation);

		return "Saved";
	}

	@GetMapping(path="/all")
	public @ResponseBody Iterable<Location> getAllLocations() {
		// This returns a JSON or XML with the users
		return userRepository.findAll();
	}
}
