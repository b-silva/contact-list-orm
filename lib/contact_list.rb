class ContactList

	attr_accessor :contacts

  def list_all
  	list(Contact.all)
	end

	def list(contacts_to_list)
		contacts_to_list.each_with_index do |contact,index|
			if index % 50 == 49
				puts "#{contact.id}: #{contact.name} (#{contact.email})"
				print "--- Press enter to continue... ---"
				STDIN.gets
			else
				puts "#{contact.id}: #{contact.name} (#{contact.email})"
			end
		end
		puts "---"
		puts "#{contacts_to_list.size} contacts total"
	end

	def create_new
		puts "Enter full name:"
		name = STDIN.gets.chomp
		puts "Enter email address:"
		email = STDIN.gets.chomp
		contact = Contact.create(name, email)
		if contact
			puts "Contact #{contact.name} created successfully with id #{contact.id}!"
		else
			puts "Unable to create contact, please ensure email is unique."
		end
	end

	def show_contact(id)
		unless id =~ /^\d+$/
			puts "Contact ID must be a number!"
			return
		end
		contact = Contact.find(id.to_i)
		if contact
			list([contact])
		else
			puts "Contact not found!"
		end
	end

	def search_contact(term)
		found_contacts = Contact.search(term)
		if found_contacts
			list(found_contacts)
		else
			puts "No contacts matched your search criteria!"
		end
	end

	def update_contact(id)
		contact = Contact.find(id)
		unless contact
			puts "Contact not found!"
			return
		end
		puts "Updating #{contact.id}: #{contact.name} (#{contact.email})"
		puts "Enter new full name:"
		contact.name = STDIN.gets.chomp
		puts "Enter new email address:"
		contact.email = STDIN.gets.chomp
		contact.save
	end

	def delete_contact(id)
		contact = Contact.find(id)
		unless contact
			puts "Contact not found!"
			return
		end
		puts "Deleting #{contact.id}: #{contact.name} (#{contact.email})"
		print "Are you sure? (y/n): "
		sure = STDIN.gets.chomp
		if sure == "y"
			contact.destroy
			puts "Contact deleted!"
		else
			puts "Operation aborted."
		end
	end

	def add_phone(id)
		contact = Contact.find(id)
		unless contact
			puts "Contact not found!"
			return
		end
		puts "Adding phone number for #{contact.id}: #{contact.name} (#{contact.email})"
		puts "Enter type of phone:"
		type = STDIN.gets.chomp
		puts "Enter phone number (exactly 10 digits, no spaces):"
		number = STDIN.gets.chomp
		unless number.length == 10
			puts "Phone number must be exactly 10 digits!"
			return
		end
		phone = Phone.new(contact.id, type, number)
		phone.save
	end

	def find_phones(id)
		contact = Contact.find(id)
		unless contact
			puts "Contact not found!"
			return
		end
		list_phones(contact, Phone.find(contact.id))
	end

	def list_phones(contact, phones_to_list)
		puts "#{contact.id}: #{contact.name} (#{contact.email})"
		puts "No phone numbers for this contact" if phones_to_list.empty?
		phones_to_list.each do |phone|
			puts "#{phone.type}: #{phone.number}"
		end
	end

	def all_phones
		contacts = Contact.all
		contacts.each do |contact|
			list_phones(contact, Phone.find(contact.id))
		end
	end

end