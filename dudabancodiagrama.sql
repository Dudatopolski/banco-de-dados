


CREATE SCHEMA IF NOT EXISTS `ECOMERCE` DEFAULT CHARACTER SET utf8 ;
USE `ECOMERCE` ;

-- Table `ECOMERCE`.`endereco`-- 
CREATE TABLE IF NOT EXISTS `ECOMERCE`.`endereco` (
  `cep` INT NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `bairro` VARCHAR(50) NOT NULL,
  `cidade` VARCHAR(50) NOT NULL,
  `estado` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`cep`))
ENGINE = InnoDB;



-- Table `ECOMERCE`.`Clientes --
CREATE TABLE IF NOT EXISTS `ECOMERCE`.`Clientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  `numero` VARCHAR(10) NOT NULL,
  `complemento` VARCHAR(50) NULL,
  `cep` VARCHAR(10) NULL,
  `Clientescol` VARCHAR(45) NULL,
  `Clientes_id` INT NOT NULL,
  `endereco_cep` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Clientes_Clientes1_idx` (`Clientes_id` ASC) VISIBLE,
  INDEX `fk_Clientes_endereco1_idx` (`endereco_cep` ASC) VISIBLE,
  CONSTRAINT `fk_Clientes_Clientes1`
    FOREIGN KEY (`Clientes_id`)
    REFERENCES `ECOMERCE`.`Clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Clientes_endereco1`
    FOREIGN KEY (`endereco_cep`)
    REFERENCES `ECOMERCE`.`endereco` (`cep`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ECOMERCE`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ECOMERCE`.`Pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_pedido` DATETIME NOT NULL,
  `status` ENUM('D', ' ') NOT NULL,
  `Clientes_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Pedido_Clientes_idx` (`Clientes_id` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Clientes`
    FOREIGN KEY (`Clientes_id`)
    REFERENCES `ECOMERCE`.`Clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ECOMERCE`.`Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ECOMERCE`.`Produto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome_produto` VARCHAR(100) NOT NULL,
  `descricao` TEXT NOT NULL,
  `preco` DECIMAL NOT NULL,
  `estoque` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ECOMERCE`.`Pedido_has_Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ECOMERCE`.`Pedido_has_Produto` (
  `Pedido_id` INT NOT NULL,
  `Produto_id` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `preco_unitario` DECIMAL(10,2) NULL,
  PRIMARY KEY (`Pedido_id`, `Produto_id`),
  INDEX `fk_Pedido_has_Produto_Produto1_idx` (`Produto_id` ASC) VISIBLE,
  INDEX `fk_Pedido_has_Produto_Pedido1_idx` (`Pedido_id` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_has_Produto_Pedido1`
    FOREIGN KEY (`Pedido_id`)
    REFERENCES `ECOMERCE`.`Pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_has_Produto_Produto1`
    FOREIGN KEY (`Produto_id`)
    REFERENCES `ECOMERCE`.`Produto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
